#!/bin/bash
! kubectl get pod exec-probe-demo 2>/dev/null | grep -q 'exec-probe-demo'
