#!/bin/bash
kubectl get deployment nginx-probes 2>/dev/null | grep -q 'nginx-probes'
