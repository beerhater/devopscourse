#!/bin/bash
test -f ~/ansible-roles-lab/site.yml && grep -q 'roles' ~/ansible-roles-lab/site.yml
