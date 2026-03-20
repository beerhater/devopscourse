#!/bin/bash
cd ~/terraform-intro && terraform plan 2>&1 | grep -q 'Plan:'
