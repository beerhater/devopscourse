#!/bin/bash
cd ~/ansible-lab && ansible all -b -m service -a 'name=nginx state=started' 2>/dev/null | grep -q 'SUCCESS'
