#!/bin/bash
test -f ~/ansible-capstone/site.yml &&
ansible webservers -i ~/ansible-lab/hosts.yml -m shell -a 'curl -s http://localhost/healthz' 2>/dev/null | grep -q 'OK'
