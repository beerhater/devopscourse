#!/bin/bash
cd ~/ansible-lab && ansible all -m shell -a 'which nginx' 2>/dev/null | grep -q 'SUCCESS'
