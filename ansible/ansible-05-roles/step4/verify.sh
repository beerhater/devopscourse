#!/bin/bash
test -f ~/ansible-roles-lab/roles/nginx/defaults/main.yml && grep -q 'nginx_port' ~/ansible-roles-lab/roles/nginx/defaults/main.yml
