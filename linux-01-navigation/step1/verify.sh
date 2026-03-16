#!/bin/bash
if [ -d "/root" ]; then
  exit 0
else
  exit 1
fi
