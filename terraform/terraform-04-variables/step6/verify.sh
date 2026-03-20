#!/bin/bash
test -f ~/tf-variables/outputs.tf && cd ~/tf-variables && terraform output deploy_id 2>/dev/null | grep -q '.'
