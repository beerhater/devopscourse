#!/bin/bash
docker images myapp:v1 --format '{{.Tag}}' | grep -q 'v1' && docker images myapp:v2 --format '{{.Tag}}' | grep -q 'v2'
