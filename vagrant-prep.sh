#!/bin/bash

# Credits to:
#  - http://vstone.eu/reducing-vagrant-box-size/
#  - https://github.com/mitchellh/vagrant/issues/343

#Delete cache of yum
yum clean all
rm -rf /var/cache/yum

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Remove bash history
export HISTSIZE=0
rm -f /root/.bash_history
rm -f /home/ec2-user/.bash_history
rm -f /home/vagrant/.bash_history

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;
