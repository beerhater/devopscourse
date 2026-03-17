#!/bin/bash
kubectl get deployment web-app -o jsonpath='{.spec.template.spec.containers[0].image}' | grep -q '1.2[5-9]\|1.[3-9]'
