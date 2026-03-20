#!/bin/bash
cd ~/ansible-lab && ansible all -m shell -a 'test -d /opt' 2>/dev/null | grep -q 'SUCCESS'
