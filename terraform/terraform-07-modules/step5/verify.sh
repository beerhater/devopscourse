#!/bin/bash
cd ~/tf-modules && terraform state list 2>/dev/null | grep 'module.app\[' | grep -q '.'
