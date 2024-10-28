#!/bin/bash

# 获取所有链的规则列表
RULES=$(iptables-save)

# 用于存储已检测过的规则
declare -A seen_rules
duplicate_found=false

# 遍历每条规则
echo "开始清理 iptables 表中的重复规则..."
while read -r line; do
    # 检查行是否是规则条目
    if [[ $line == "-A "* ]]; then
        # 提取链名和规则内容
        chain=$(echo "$line" | awk '{print $2}')
        rule_content=$(echo "$line" | sed "s/-A $chain //")

        # 检查规则是否已被记录
        if [[ -n "${seen_rules["$chain $rule_content"]}" ]]; then
            # 如果是重复规则，则删除
            echo "删除重复规则：$chain $rule_content"
            iptables -D $chain $rule_content
            duplicate_found=true
        else
            # 如果不是重复规则，记录该规则
            seen_rules["$chain $rule_content"]=1
        fi
    fi
done <<< "$RULES"

if [ "$duplicate_found" = true ]; then
    echo "清理完成！"
else
    echo "未找到重复规则。"
fi
