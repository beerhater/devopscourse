#!/bin/bash
docker ps | grep -qi "web" && exit 0 || exit 1
