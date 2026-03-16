#!/bin/bash
test -f /opt/final-project/my-pipeline.sh && docker images calculator | grep -q "1.0"
