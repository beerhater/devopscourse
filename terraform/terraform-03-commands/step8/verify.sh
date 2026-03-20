#!/bin/bash
cd ~/tf-commands && terraform output config_path 2>/dev/null | grep -q '/tmp'
