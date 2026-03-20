#!/bin/bash
test -f ~/tf-workflow/main.tf &&
cd ~/tf-workflow && terraform validate 2>/dev/null | grep -qi 'success\|valid'
