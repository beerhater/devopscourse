#!/bin/bash
test -f /tmp/tf-demo/db.password && stat -c '%a' /tmp/tf-demo/db.password | grep -q '600'
