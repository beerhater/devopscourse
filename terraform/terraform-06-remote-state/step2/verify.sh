#!/bin/bash
mc ls local/terraform-state/dev/ 2>/dev/null | grep -q 'terraform.tfstate'
