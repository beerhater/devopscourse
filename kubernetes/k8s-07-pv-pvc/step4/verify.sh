#!/bin/bash
set -e
kubectl get pvc pvc-demo 2>/dev/null | grep -q 'Bound'
[ -s /root/pvc_persistence.log ]
grep -q 'Persistent data: pod started at' /root/pvc_persistence.log
grep -q 'New pod appended at' /root/pvc_persistence.log
