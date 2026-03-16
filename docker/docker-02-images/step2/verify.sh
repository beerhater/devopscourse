#!/bin/bash
docker images | grep -q "alpine" && docker images | grep -q "nginx"
