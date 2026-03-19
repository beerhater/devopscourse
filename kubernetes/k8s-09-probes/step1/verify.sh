#!/bin/bash
! kubectl get pod broken-pod 2>/dev/null | grep -q 'Running'
