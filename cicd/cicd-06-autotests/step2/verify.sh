#!/bin/bash
cd /opt/autotests-demo && python3 -m pytest test_bank.py -q 2>/dev/null | grep -q "passed"
