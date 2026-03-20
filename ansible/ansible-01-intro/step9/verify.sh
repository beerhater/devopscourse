#!/bin/bash
cd ~/ansible-lab && ansible all -m setup -a 'filter=ansible_hostname' 2>/dev/null | grep -q 'SUCCESS'
