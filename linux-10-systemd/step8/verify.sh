#!/bin/bash
grep -q "Wants" "/etc/systemd/system/myapp.service" && exit 0 || exit 1
