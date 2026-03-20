#!/bin/bash
cd ~/ansible-lab && ansible all -m shell -a 'curl -s http://localhost/healthz' 2>/dev/null | grep -q 'OK'
