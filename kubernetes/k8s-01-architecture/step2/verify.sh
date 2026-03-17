#!/bin/bash
kubectl get pods -n kube-system | grep -q 'kube-apiserver'
