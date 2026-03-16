#!/bin/bash
docker network ls | grep -q "mynet" && exit 1 || exit 0
