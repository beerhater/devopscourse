#!/bin/bash
docker images | grep -q "cmd-demo" && docker images | grep -q "entrypoint-demo"
