#!/bin/bash
systemctl is-active myapp &>/dev/null && exit 0 || exit 1
