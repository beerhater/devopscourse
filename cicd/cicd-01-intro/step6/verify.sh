#!/bin/bash
test -f /opt/myapp/Dockerfile && docker images myapp | grep -q "latest"
