#!/bin/bash
docker volume ls | grep -q "mydata" && exit 1 || exit 0
