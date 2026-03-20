#!/bin/bash
cd ~/ansible-lab && ansible all -m shell -a 'test -f /tmp/hello.txt' 2>/dev/null | grep -q 'SUCCESS'
