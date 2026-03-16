#!/bin/bash
which gitlab-runner > /dev/null 2>&1 && test -f /opt/gitlab-ci-demo/app.py && test -f /opt/gitlab-ci-demo/tests.py
