#!/bin/bash
docker ps -a | grep -q "mywebserver" && exit 0 || exit 1
