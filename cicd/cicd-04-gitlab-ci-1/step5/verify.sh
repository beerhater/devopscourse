#!/bin/bash
test -f /opt/gitlab-ci-demo/artifacts-demo.gitlab-ci.yml && test -f /opt/gitlab-ci-demo/cache-demo.gitlab-ci.yml && grep -q "artifacts:" /opt/gitlab-ci-demo/artifacts-demo.gitlab-ci.yml
