#!/bin/bash
mc ls local/terraform-state/migrate-demo/ 2>/dev/null | grep -q 'terraform.tfstate'
