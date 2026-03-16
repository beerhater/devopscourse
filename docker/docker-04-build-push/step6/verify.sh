#!/bin/bash
docker ps | grep -q "local-registry" && curl -s http://localhost:5000/v2/_catalog | grep -q "buildapp"
