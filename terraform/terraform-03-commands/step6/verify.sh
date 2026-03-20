#!/bin/bash
cd ~/tf-commands && terraform state list 2>/dev/null | grep -q 'local_file\|random'
