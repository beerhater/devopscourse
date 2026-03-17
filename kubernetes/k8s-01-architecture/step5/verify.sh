#!/bin/bash
kubectl get pod demo 2>/dev/null | grep -E 'Running|ContainerCreating'
