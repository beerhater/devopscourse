#!/bin/bash
terraform version 2>/dev/null | grep -q 'Terraform v' && test -f ~/tf-state/terraform.tfstate
