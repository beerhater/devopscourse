#!/bin/bash
docker ps | grep -q "nginx-pub" || docker ps | grep -q "nginx-local"
