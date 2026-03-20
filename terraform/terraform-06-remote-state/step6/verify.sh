#!/bin/bash
mc ls local/terraform-state/multienv/ 2>/dev/null | grep -q '.'
