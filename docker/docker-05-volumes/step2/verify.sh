#!/bin/bash
docker volume ls | grep -q "mydata" && exit 0 || exit 1
