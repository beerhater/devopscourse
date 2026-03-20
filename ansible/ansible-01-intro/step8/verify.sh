#!/bin/bash
test -f ~/ansible-lab/hosts.yml && grep -q 'webservers' ~/ansible-lab/hosts.yml
