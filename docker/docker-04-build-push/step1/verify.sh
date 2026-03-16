#!/bin/bash
docker images | grep -q "webserver" && exit 0 || exit 1
