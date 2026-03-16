#!/bin/bash
systemctl is-active nginx &>/dev/null && exit 0 || exit 1
