#!/bin/bash
systemctl is-enabled nginx &>/dev/null && exit 0 || exit 1
