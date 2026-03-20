#!/bin/bash
ansible webservers -m shell -a 'systemctl is-active nginx' 2>/dev/null | grep -q 'active'
