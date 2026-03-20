#!/bin/bash
test -f /tmp/final-remote/production/app.conf &&
grep -q 'network_id' /tmp/final-remote/production/app.conf
