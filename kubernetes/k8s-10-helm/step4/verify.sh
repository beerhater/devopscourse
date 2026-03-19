#!/bin/bash
grep -q 'replicaCount' myapp-chart/values.yaml 2>/dev/null
