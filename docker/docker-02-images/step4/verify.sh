#!/bin/bash
docker inspect nginx &>/dev/null && exit 0 || exit 1
