#!/bin/bash
[ -f /root/prodstack/.env ] && grep -q "POSTGRES_PASSWORD" /root/prodstack/.env && exit 0 || exit 1
