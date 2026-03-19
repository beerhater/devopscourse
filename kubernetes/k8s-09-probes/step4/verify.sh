#!/bin/bash
kubectl get deployment both-probes 2>/dev/null | grep -q 'both-probes'
