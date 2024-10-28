#!/bin/bash

# 从外部文件加载要删除的规则列表
rules=()
while IFS= read -r line; do
  rules+=("$line")
done < "$(pwd)/rules_to_delete.txt"

# 遍历规则并删除
for rule in "${rules[@]}"; do
  iptables -D $rule
  if [ $? -eq 0 ]; then
    echo "成功删除规则: $rule"
  else
    echo "无法删除规则: $rule"
  fi
done
