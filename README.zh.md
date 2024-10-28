[English](README.md) | [中文](README.zh.md)

## apply_and_cleanup.sh 

### 功能简述

自动加载并管理存储在一个文件中的 `iptables` 防火墙规则，确保规则有效且不会重复添加（由[clean_duplicate_rules.sh](https://github.com/Catchabox/iptables-rule-reboot-cleaner/blob/main/clean_duplicate_rules.sh) 实现），在机器重启以后规则依旧生效，也就是对iptables的规则进行了部分的持久化，这样既不会污染大面积的iptables，也对需要的iptables有了控制权。在"**iptables_rules.txt**"文档中如果在规则前加上\*\*可以做到删除标记，也就是将该规则按照[delete_rules.sh](https://github.com/Catchabox/iptables-rule-reboot-cleaner/blob/main/delete_rules.sh)的要求放入"**rules_to_delete.txt**",但是不会主动删除，需要手动执行删除脚本，该功能方便调试，因为该脚本联动了**corn**进行了持久化，所以尽量不要在"**iptables_rules.txt**"写大量的\*\*，虽然不会影响功能，但是会影响阅读体验

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

## delete_rules.sh

### 功能简述

上述添加了不想要的规则可以通过该脚本删除，将想要剔除的规则按照下面用法的格式放入"**rules_to_delete.txt**"文件即可，但是该脚本不会修改"**iptables_rules.txt**"内容，请自行修改

### 用法

``````
DOCKER-USER -s 0.0.0.0/0 -d 172.20.0.0/16 -j DROP
DOCKER-USER -s 127.0.0.1 -d 172.20.0.0/16 -j ACCEPT
DOCKER-USER -s 172.20.0.0/16 -d 127.0.0.1 -j ACCEPT
``````

注意：不需要在前面加`iptables -I`即可生效
