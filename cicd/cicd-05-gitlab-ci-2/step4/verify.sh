#!/bin/bash
test -f /opt/gitlab-ci-2-demo/extends-demo.gitlab-ci.yml && grep -q "extends:" /opt/gitlab-ci-2-demo/extends-demo.gitlab-ci.yml
