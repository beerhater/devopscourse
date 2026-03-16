#!/bin/bash
docker ps -a | grep -qi "web" && exit 1 || exit 0
