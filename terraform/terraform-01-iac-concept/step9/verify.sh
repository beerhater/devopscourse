#!/bin/bash
cd ~/terraform-project && terraform validate 2>/dev/null | grep -q -i 'success\|valid'
