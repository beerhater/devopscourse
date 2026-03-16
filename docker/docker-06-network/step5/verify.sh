#!/bin/bash
docker network ls | grep -q "frontend-net" && docker network ls | grep -q "backend-net"
