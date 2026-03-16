#!/bin/bash
docker images --format '{{.Repository}}' | grep -q "." || docker images | grep -q "REPOSITORY"
