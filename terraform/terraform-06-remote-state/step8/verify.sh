#!/bin/bash
test -f /tmp/remote-data/application.conf && grep -q 'vpc_id' /tmp/remote-data/application.conf
