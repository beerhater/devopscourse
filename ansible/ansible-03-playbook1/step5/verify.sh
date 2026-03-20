#!/bin/bash
test -d /opt/app/logs 2>/dev/null && echo ok || ansible all -b -m shell -a 'test -d /opt/app' 2>/dev/null | grep -q 'SUCCESS'
