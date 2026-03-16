#!/bin/bash
[ -f /root/myapp/Dockerfile ] && grep -q "FROM ubuntu" /root/myapp/Dockerfile && exit 0 || exit 1
