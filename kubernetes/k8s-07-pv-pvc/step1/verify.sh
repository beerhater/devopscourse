#!/bin/bash
! kubectl get pod ephemeral 2>/dev/null | grep -q 'Running'
