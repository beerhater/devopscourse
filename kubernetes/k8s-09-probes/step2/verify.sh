#!/bin/bash
! kubectl get pod liveness-http 2>/dev/null | grep -q 'liveness-http$'
