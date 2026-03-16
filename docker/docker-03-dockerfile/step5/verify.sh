#!/bin/bash
[ -f /root/myapp/Dockerfile.optimized ] && grep -q "alpine" /root/myapp/Dockerfile.optimized && exit 0 || exit 1
