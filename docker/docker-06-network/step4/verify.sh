#!/bin/bash
docker network inspect mynet 2>/dev/null | grep -q "app" && exit 0 || exit 1
