#!/bin/bash
kubectl describe pod my-nginx 2>/dev/null | grep -q 'Running'
