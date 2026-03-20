#!/bin/bash
test -f ~/terraform-final/main.tf &&
test -f ~/terraform-final/variables.tf &&
test -f ~/terraform-final/outputs.tf &&
cd ~/terraform-final && terraform validate 2>/dev/null | grep -qi 'success\|valid'
