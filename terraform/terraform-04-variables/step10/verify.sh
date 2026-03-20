#!/bin/bash
cd ~/tf-final-lesson4 && terraform validate 2>/dev/null | grep -qi 'success\|valid' &&
grep -q 'validation' variables.tf
