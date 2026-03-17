#!/bin/bash
kubectl config get-contexts | grep -qE 'development|dev'
