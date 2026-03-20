#!/bin/bash
test -f ~/ansible-roles-lab/site.yml &&
test -d ~/ansible-roles-lab/roles/nginx &&
test -d ~/ansible-roles-lab/roles/app &&
test -d ~/ansible-roles-lab/roles/common &&
ansible webservers -i ~/ansible-roles-lab/hosts.yml -m shell -a 'curl -s http://localhost/healthz' 2>/dev/null | grep -q 'OK'
