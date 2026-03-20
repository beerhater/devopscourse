#!/bin/bash
test -f ~/tf-state/terraform.tfstate && cat ~/tf-state/terraform.tfstate | grep -q 'serial'
