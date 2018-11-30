#!/bin/bash
#Delete Bash command history
export HISTSIZE=0
#Delete cache of yum
yum clean all
rm -rf /var/cache/yum
#Optimize the area of ​​the virtual hard disk
dd if=/dev/zero of=/ZERO bs=1M
rm -f /ZERO
