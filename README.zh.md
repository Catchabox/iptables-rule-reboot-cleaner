[English](README.md) | [中文](README.zh.md)

## apply_and_cleanup.sh 

### 功能简述

自动加载并管理存储在一个文件中的 `iptables` 防火墙规则，确保规则有效且不会重复添加（由[clean_duplicate_rules.sh](https://github.com/Catchabox/iptables-rule-reboot-cleaner/blob/main/clean_duplicate_rules.sh) 实现），在机器重启以后规则依旧生效

### 用法

[apply_and_cleanup.sh](https://github.com/Catchabox/iptables-rule-reboot-cleaner/blob/main/apply_and_cleanup.sh)需要在同一目录下创建一个"**iptables_rules.txt**"文件,在该TXT文档里面书写iptables规则，例如:

```
iptables -I DOCKER-USER -s 0.0.0.0/0 -d 172.20.0.0/16 -j DROP
iptables -I DOCKER-USER -s 127.0.0.1 -d 172.20.0.0/16 -j ACCEPT
iptables -I DOCKER-USER -s 172.20.0.0/16 -d 127.0.0.1 -j ACCEPT
```

保存之后，记得基于脚本执行权限

``````
chmod +x apply_and_cleanup.sh
chmod +x clean_duplicate_rules.sh
``````

执行即可

``````
bash apply_and_cleanup.sh
``````

## clean_duplicate_rules.sh

### 功能简述

可以单独执行，清理`DOCKER-USER 链中的重复规则列表`可以根据需求进行修改
