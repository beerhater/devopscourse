#!/bin/bash
docker images | grep -qi "alpine" && exit 0 || exit 1
