#!/bin/bash
kubectl config get-contexts 2>/dev/null | grep -qE 'dev-context|development'
