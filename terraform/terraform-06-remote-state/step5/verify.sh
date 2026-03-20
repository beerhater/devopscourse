#!/bin/bash
mc ls --versions local/terraform-state/dev/ 2>/dev/null | grep -q 'terraform.tfstate'
