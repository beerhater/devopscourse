#!/bin/bash
test -f /tmp/tf-vars/db.conf && grep -q 'database' /tmp/tf-vars/db.conf
