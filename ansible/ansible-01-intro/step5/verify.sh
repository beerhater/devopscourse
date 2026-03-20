#!/bin/bash
test -f ~/ansible-lab/ansible.cfg && grep -q 'inventory' ~/ansible-lab/ansible.cfg
