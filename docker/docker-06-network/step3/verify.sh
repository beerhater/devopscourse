#!/bin/bash
docker network ls | grep -q "mynet" && exit 0 || exit 1
