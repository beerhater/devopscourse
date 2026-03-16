#!/bin/bash
grep -q "if \[ " "/root/check_num.sh" && exit 0 || exit 1
