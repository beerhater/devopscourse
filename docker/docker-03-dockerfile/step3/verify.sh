#!/bin/bash
grep -q "ENV" /root/myapp/Dockerfile && grep -q "EXPOSE" /root/myapp/Dockerfile && exit 0 || exit 1
