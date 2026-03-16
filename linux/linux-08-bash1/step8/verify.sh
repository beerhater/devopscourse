#!/bin/bash
ls /root/*.log.bak 1>/dev/null 2>&1 && exit 0 || exit 1
