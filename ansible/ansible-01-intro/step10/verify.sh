#!/bin/bash
test -f ~/ansible-final/ansible.cfg &&
test -f ~/ansible-final/inventory.yml &&
cd ~/ansible-final && ansible all -m ping 2>/dev/null | grep -q 'SUCCESS'
