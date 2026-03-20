#!/bin/bash
test -f ~/ansible-roles-lab/roles/nginx/meta/main.yml && grep -q 'dependencies' ~/ansible-roles-lab/roles/nginx/meta/main.yml
