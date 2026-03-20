#!/bin/bash
cd ~/ansible-lab && ansible all -m shell -a 'hostname' 2>/dev/null | grep -q 'SUCCESS'
