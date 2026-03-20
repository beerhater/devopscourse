#!/bin/bash
cd ~/tf-state && terraform state list 2>/dev/null | grep -q 'local_file'
