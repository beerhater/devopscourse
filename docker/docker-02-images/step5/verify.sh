#!/bin/bash
docker images | grep -qi "postgres" && exit 1 || exit 0
