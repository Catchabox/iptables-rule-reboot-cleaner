#!/bin/bash

# 指定存放 iptables 规则的文件路径
RULES_FILE="$(pwd)/iptables_rules.txt"
TEMP_SCRIPT="$(pwd)/temp_iptables.sh"
CLEANUP_SCRIPT="$(pwd)/clean_duplicate_rules.sh"
RULES_TO_DELETE_FILE="$(pwd)/rules_to_delete.txt"

# 创建一个临时脚本来执行这些 iptables 规则
echo "#!/bin/bash" > "$TEMP_SCRIPT"
chmod +x "$TEMP_SCRIPT"

# 创建一个文件来存储要删除的规则
echo "" > "$RULES_TO_DELETE_FILE"

# 避免重复添加规则的函数
function rule_exists {
    # 检查规则是否已存在于 iptables 中
    iptables-save | grep -F "$1" >/dev/null 2>&1
}

# 应用规则并避免重复
ADDED_RULES=()
REMOVED_RULES=()
while read -r line; do
    # 跳过空行
    if [[ -z "$line" ]]; then
        continue
    fi

    # 如果是以 ** 开头的规则，提取相应的规则并写入删除文件
    if [[ "$line" =~ ^\*\*.*$ ]]; then
        rule="${line#\*\*iptables }"
        rule="${rule#-I }"
        echo "$rule" >> "$RULES_TO_DELETE_FILE"
        REMOVED_RULES+=("$rule")
        continue
    fi

    # 如果是正常的 iptables 规则
    if [[ "$line" =~ ^iptables.*$ ]]; then
        # 移除 "iptables " 前缀，仅保留规则部分以供检查
        rule="${line#iptables }"

        # 检查规则是否已存在
        if ! rule_exists "$rule"; then
            # 如果不存在，则添加规则，并捕获错误信息
            if ! iptables $rule 2>/tmp/iptables_error.log; then
                echo "无法添加规则：$line"
                echo "错误信息：$(cat /tmp/iptables_error.log)"
                continue
            fi
            # 记录添加的规则
            ADDED_RULES+=("$line")
        else
            echo "规则已存在：$line"
        fi
    fi
done < "$RULES_FILE"

echo "iptables 规则已成功应用。"

# 显示添加的规则
if [ ${#ADDED_RULES[@]} -gt 0 ]; then
    echo "已添加的规则："
    for rule in "${ADDED_RULES[@]}"; do
        echo "$rule"
    done
else
    echo "没有添加新的规则。"
fi

# 显示要移除的规则
if [ ${#REMOVED_RULES[@]} -gt 0 ]; then
    echo "已标记为移除的规则："
    for rule in "${REMOVED_RULES[@]}"; do
        echo "$rule"
    done
else
    echo "没有标记为移除的规则。"
fi

# 检查并执行清理脚本
if [[ -f "$CLEANUP_SCRIPT" ]]; then
    echo "检测到清理脚本，开始执行..."
    bash "$CLEANUP_SCRIPT"
else
    echo "未找到清理脚本：$CLEANUP_SCRIPT"
fi
