#!/bin/bash
test -f ~/tf-state/.gitignore && grep -q 'tfstate' ~/tf-state/.gitignore
