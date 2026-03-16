#!/bin/bash
[ -f /root/myapp/app.sh ] && grep -q "COPY app.sh" /root/myapp/Dockerfile && exit 0 || exit 1
