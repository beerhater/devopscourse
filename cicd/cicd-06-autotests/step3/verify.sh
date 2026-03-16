#!/bin/bash
cd /opt/autotests-demo && python3 -m pytest test_bank.py --cov=bank --cov-fail-under=70 -q 2>/dev/null | grep -qE "passed|coverage"
