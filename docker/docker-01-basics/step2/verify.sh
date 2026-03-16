#!/bin/bash
docker ps -a | grep -qi "hello-world" && exit 0 || exit 1
