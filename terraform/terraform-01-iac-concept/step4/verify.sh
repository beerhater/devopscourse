#!/bin/bash
test -f ~/terraform-intro/main.tf && grep -q 'required_providers' ~/terraform-intro/main.tf
