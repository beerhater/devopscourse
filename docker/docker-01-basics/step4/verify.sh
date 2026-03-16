#!/bin/bash
status=$(docker inspect -f '{{.State.Status}}' my-nginx 2>/dev/null)
[ "$status" = "exited" ]
