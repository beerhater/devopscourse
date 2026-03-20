#!/bin/bash
cd ~/tf-remote && terraform state list 2>/dev/null | grep -q '.'
