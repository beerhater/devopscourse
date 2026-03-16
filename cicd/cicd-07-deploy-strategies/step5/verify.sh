#!/bin/bash
test -f /opt/deploy-demo/app_with_flags.py && grep -q 'FF_NEW_DASHBOARD' /opt/deploy-demo/app_with_flags.py
