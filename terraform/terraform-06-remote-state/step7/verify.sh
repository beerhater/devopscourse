#!/bin/bash
cd ~/tf-workspace && terraform workspace list 2>/dev/null | grep -q 'staging'
