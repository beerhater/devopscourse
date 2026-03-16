#!/bin/bash
docker volume ls | grep -q "pgdata" && exit 0 || exit 1
