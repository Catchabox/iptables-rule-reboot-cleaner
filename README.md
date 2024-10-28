[English](README.md) | [Chinese](README.zh.md)

## apply_and_cleanup.sh 

### Description

Automatically loads and manages `iptables` firewall rules stored in a file, ensuring that they are valid and not duplicated (as defined by [clean_duplicate_rules.sh](https://github.com/Catchabox/iptables-rule-reboot-)). cleaner/blob/main/clean_duplicate_rules.sh)), and that the rules remain in effect after a machine reboot.

### Usage

[apply_and_cleanup.sh](https://github.com/Catchabox/iptables-rule-reboot-cleaner/blob/main/apply_and_cleanup.sh) requires that a “**iptables_rules.txt**” file in the same directory, and write the iptables rules in this TXT file, for example.

```
iptables -I DOCKER-USER -s 0.0.0.0/0 -d 172.20.0.0/16 -j DROP
iptables -I DOCKER-USER -s 127.0.0.1 -d 172.20.0.0/16 -j ACCEPT
iptables -I DOCKER-USER -s 172.20.0.0/16 -d 127.0.0.1 -j ACCEPT
```

After saving, remember to execute the script based on the permissions

``````
chmod +x apply_and_cleanup.sh
chmod +x clean_duplicate_rules.sh
``````

Just run it

``````
bash apply_and_cleanup.sh
``````
## clean_duplicate_rules.sh

### Description

Can be executed separately to clean up the list of duplicate rules in the `DOCKER-USER chain`, which can be modified according to your needs.

## delete_rules.sh

### Brief description of function

This script deletes unwanted rules, but it does not modify the content of “**rules_to_delete.txt**”, so please modify it yourself.

### Usage

``````
DOCKER-USER -s 0.0.0.0/0 -d 172.20.0.0/16 -j DROP
DOCKER-USER -s 127.0.0.1 -d 172.20.0.0/16 -j ACCEPT
DOCKER-USER -s 172.20.0.0/16 -d 127.0.0.1 -j ACCEPT
``````

You don't need to add `iptables -I` in front of it for it to take effect
