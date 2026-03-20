#!/bin/bash
cd ~/tf-state-final && test -f main.tf &&
terraform validate 2>/dev/null | grep -qi 'success\|valid'
