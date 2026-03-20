#!/bin/bash
cd ~/ansible-lab && ansible-playbook playbooks/install_nginx.yml --check 2>/dev/null | grep -q 'PLAY RECAP'
