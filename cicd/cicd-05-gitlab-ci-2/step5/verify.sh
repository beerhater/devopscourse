#!/bin/bash
test -f /opt/gitlab-ci-2-demo/environments.gitlab-ci.yml && grep -q "environment:" /opt/gitlab-ci-2-demo/environments.gitlab-ci.yml
