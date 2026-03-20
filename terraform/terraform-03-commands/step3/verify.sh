#!/bin/bash
cd ~/tf-commands && terraform validate 2>/dev/null | grep -qi 'success\|valid'
