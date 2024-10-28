#!/bin/bash

# 获取 DOCKER-USER 链中的规则列表
RULES=$(iptables -S DOCKER-USER)

# 用于存储已检测过的规则
declare -A seen_rules
duplicate_found=false

# 遍历每条规则
echo "开始清理 DOCKER-USER 链中的重复规则..."
while read -r line; do
    # 过滤出规则内容部分
    rule_content=$(echo "$line" | sed 's/^-A DOCKER-USER //')

    # 检查规则是否已被记录
    if [[ -n "${seen_rules["$rule_content"]}" ]]; then
        # 如果是重复规则，则删除
        echo "删除重复规则：$rule_content"
        iptables -D DOCKER-USER $rule_content
        duplicate_found=true
    else
        # 如果不是重复规则，记录该规则
        seen_rules["$rule_content"]=1
    fi
done <<< "$RULES"

if [ "$duplicate_found" = true ]; then
    echo "清理完成！"
else
    echo "未找到重复规则。"
fi
