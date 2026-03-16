#!/bin/bash
cd /opt/final-autotests && python3 -m pytest test_shop.py --cov=shop --cov-fail-under=80 -q 2>/dev/null | grep -q 'passed'
