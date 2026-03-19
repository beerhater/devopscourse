#!/bin/bash
helm list 2>/dev/null | grep -q 'myapp-release'
