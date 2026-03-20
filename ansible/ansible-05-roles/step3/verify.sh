#!/bin/bash
test -f ~/ansible-roles-lab/roles/nginx/tasks/main.yml && grep -q 'nginx' ~/ansible-roles-lab/roles/nginx/tasks/main.yml
