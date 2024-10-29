#!/bin/bash

# 文件名包含要删除的iptables规则
RULES_FILE="$(pwd)/rules_to_delete.txt"

# 检查文件是否存在
if [ ! -f "$RULES_FILE" ]; then
  echo "规则文件 $RULES_FILE 不存在。请创建该文件并包含要删除的规则。"
  exit 1
fi

# 逐行读取规则文件并删除规则
while IFS= read -r rule || [ -n "$rule" ]; do
  # 跳过空行和注释
  [[ -z "$rule" || "$rule" =~ ^#.* ]] && continue
  
  # 删除规则
  echo "尝试删除规则: $rule"
  eval "$rule"
  if [ $? -eq 0 ]; then
    echo "成功删除规则: $rule"
  else
    echo "删除规则失败: $rule"
  fi
done < <(cat "$RULES_FILE")

echo "完成规则删除操作。"

