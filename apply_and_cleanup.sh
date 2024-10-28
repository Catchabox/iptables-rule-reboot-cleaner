#!/bin/bash

# 指定存放 iptables 规则的文件路径
RULES_FILE="$(pwd)/iptables_rules.txt"
TEMP_SCRIPT="$(pwd)/temp_iptables.sh"
CLEANUP_SCRIPT="$(pwd)/clean_duplicate_rules.sh"

# 创建一个临时脚本来执行这些 iptables 规则
echo "#!/bin/bash" > "$TEMP_SCRIPT"
chmod +x "$TEMP_SCRIPT"

# 避免重复添加规则的函数
function rule_exists {
    # 检查规则是否已存在于 iptables 中
    iptables-save | grep -F "$1" >/dev/null 2>&1
}

# 验证规则文件中的所有规则是否有效
while read -r line; do
    # 跳过空行和注释行
    [[ -z "$line" || "$line" =~ ^#.*$ ]] && continue

    # 移除“iptables ”前缀，仅保留规则部分以供检查
    rule="${line#iptables }"

    # 检查规则是否有效，并捕获错误信息
    if ! iptables $rule 2>/tmp/iptables_error.log; then
        # 显示详细的错误信息
        echo "无效的规则：$line"
        echo "错误信息：$(cat /tmp/iptables_error.log)"
        echo "停止执行，请检查规则文件 $RULES_FILE"
        exit 1
    fi

    # 将有效的规则写入临时脚本中
    echo "$line" >> "$TEMP_SCRIPT"
done < "$RULES_FILE"

# 避免 crontab 重复条目
CRON_CMD="@reboot $TEMP_SCRIPT"
(crontab -l 2>/dev/null | grep -F "$CRON_CMD") || (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
echo "Crontab 已更新，在启动时将执行 iptables 规则。"

# 应用规则并避免重复
while read -r line; do
    # 移除“iptables ”前缀，仅保留规则部分以供检查
    rule="${line#iptables }"

    # 检查规则是否已存在
    if ! rule_exists "$rule"; then
        # 如果不存在，则添加规则，并捕获错误信息
        if ! iptables $rule 2>/tmp/iptables_error.log; then
            echo "无法添加规则：$line"
            echo "错误信息：$(cat /tmp/iptables_error.log)"
            continue
        fi
    else
        echo "规则已存在：$line"
    fi
done < "$RULES_FILE"
echo "iptables 规则已成功应用。"

# 检查并执行清理脚本
if [[ -f "$CLEANUP_SCRIPT" ]]; then
    echo "检测到清理脚本，开始执行..."
    bash "$CLEANUP_SCRIPT"
else
    echo "未找到清理脚本：$CLEANUP_SCRIPT"
fi
