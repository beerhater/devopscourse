#!/bin/bash
grep -q "CMD" /root/myapp/Dockerfile && exit 0 || exit 1
