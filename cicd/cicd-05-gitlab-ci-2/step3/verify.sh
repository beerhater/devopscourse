#!/bin/bash
test -d /opt/gitlab-ci-2-demo/ci && test -f /opt/gitlab-ci-2-demo/ci/test.yml && test -f /opt/gitlab-ci-2-demo/ci/docker.yml && test -f /opt/gitlab-ci-2-demo/ci/deploy.yml
