#!/bin/bash
cd ~/ansible-lab && ansible all -m ping 2>/dev/null | grep -q 'SUCCESS\|pong'
