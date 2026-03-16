#!/bin/bash
cd /opt/autotests-demo && python3 -m pytest test_bank.py --junitxml=/tmp/jr.xml -q 2>/dev/null && test -f /tmp/jr.xml
