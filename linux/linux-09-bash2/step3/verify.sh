#!/bin/bash
[ -x "/root/func.sh" ] && grep -q "function " "/root/func.sh" && exit 0 || exit 1
