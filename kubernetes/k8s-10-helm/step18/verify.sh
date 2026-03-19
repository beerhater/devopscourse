#!/bin/bash
helm list --all-namespaces 2>/dev/null | grep -q 'devapp'
