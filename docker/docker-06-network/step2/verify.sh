#!/bin/bash
docker ps -a | grep -qE "c1|c2" && exit 0 || exit 1
