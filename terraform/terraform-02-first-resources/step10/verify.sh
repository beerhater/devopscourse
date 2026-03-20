#!/bin/bash
cd ~/tf-final-lesson2 && terraform validate 2>/dev/null | grep -qi 'success\|valid' &&
test -f ~/tf-final-lesson2/main.tf
