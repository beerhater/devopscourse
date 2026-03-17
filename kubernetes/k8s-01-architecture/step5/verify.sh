#!/bin/bash
kubectl get pod my-nginx | grep -E 'Running|ContainerCreating'
