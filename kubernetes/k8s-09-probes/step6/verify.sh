#!/bin/bash
! kubectl get pod startup-demo 2>/dev/null | grep -q 'startup-demo'
