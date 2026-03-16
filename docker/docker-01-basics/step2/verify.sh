#!/bin/bash
docker ps --filter "name=my-nginx" --filter "status=running" | grep -q "my-nginx"
