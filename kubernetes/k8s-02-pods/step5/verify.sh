#!/bin/bash
! kubectl get pod crash-demo 2>/dev/null | grep -q 'crash-demo'
