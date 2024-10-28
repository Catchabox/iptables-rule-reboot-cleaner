[English](README.md) | [Chinese](README.zh.md)

## apply_and_cleanup.sh 

### Description

Automatically loads and manages `iptables` firewall rules stored in a file, ensuring that they are valid and not duplicated (as defined by [clean_duplicate_rules.sh](https://github.com/Catchabox/iptables-rule-reboot-)). cleaner/blob/main/clean_duplicate_rules.sh)), the rules remain in effect after the machine is rebooted, that is, the iptables rules are partially persistent, so as not to contaminate a large area of iptables, but also to have control over the iptables that need it. In the “**iptables_rules.txt**” document, if you add \*\* in front of the rule can be done to mark the deletion of the rule, that is, the rule in accordance with the [delete_rules.sh](https://github.com/Catchabox/iptables-rule-reboot-) cleaner/blob/main/delete_rules.sh) into the “**rules_to_delete.txt**”, but will not be actively deleted, you need to manually execute the delete script, the function is convenient for debugging, because the script linked to the **corn** for persistence, so try not to “** iptables_rules.sh**”, but also to delete the rule, you need to manually execute the delete script, this function is convenient for debugging, because the script linked to the **corn** for persistence, so try not to “** iptables_rules.sh**”. iptables_rules.txt**”, try not to write a lot of \*\*, although it will not affect the function, but it will affect the reading experience!

### Usage

[apply_and_cleanup.sh](https://github.com/Catchabox/iptables-rule-reboot-cleaner/blob/main/apply_and_cleanup.sh) needs to create a "**iptables_rules.txt**" file in the same directory, and write the iptables rules in this TXT file, for example.

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

Can be executed separately to clean up the list of duplicate rules in the `DOCKER-USER chain`, which can be modified as needed.

## delete_rules.sh

### Brief description of function

You can delete the rules you don't want by this script, you can put the rules you want to delete into the file “**rules_to_delete.txt**” according to the format of the following usage, but this script won't modify the content of “**iptables_rules.txt**”, please modify it by yourself.

### Usage

``````
DOCKER-USER -s 0.0.0.0/0 -d 172.20.0.0/16 -j DROP
DOCKER-USER -s 127.0.0.1 -d 172.20.0.0/16 -j ACCEPT
DOCKER-USER -s 172.20.0.0/16 -d 127.0.0.1 -j ACCEPT
``````

Note: You don't need to add `iptables -I` in front of it to make it work!
