#!/bin/bash
docker images | grep -q "webserver.*v2" && exit 0 || exit 1
