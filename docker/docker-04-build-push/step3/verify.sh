#!/bin/bash
docker images | grep -q "webserver.*latest" && exit 0 || exit 1
