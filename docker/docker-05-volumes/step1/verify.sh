#!/bin/bash
docker ps -a | grep -q "test" && exit 0 || exit 1
