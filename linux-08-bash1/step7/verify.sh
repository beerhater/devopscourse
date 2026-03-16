#!/bin/bash
grep -q "for " "/root/loop.sh" && exit 0 || exit 1
