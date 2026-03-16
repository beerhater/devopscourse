#!/bin/bash
cd /opt/autotests-demo && python3 -m pytest test_bank.py -n auto -q --no-cov 2>/dev/null | grep -q "passed"
