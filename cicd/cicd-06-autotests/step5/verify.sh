#!/bin/bash
export PATH=$PATH:/usr/local/go/bin
test -f /opt/go-tests-demo/calculator_test.go && cd /opt/go-tests-demo && go test ./... -q 2>/dev/null | grep -q 'ok\|PASS'
