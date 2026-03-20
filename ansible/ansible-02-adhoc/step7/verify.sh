#!/bin/bash
cd ~/ansible-lab && ansible all -m shell -a 'id deploy' 2>/dev/null | grep -q 'SUCCESS'
