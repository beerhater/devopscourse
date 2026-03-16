#!/bin/bash
test -f /opt/gitlab-ci-2-demo/.gitlab-ci.yml && test -f /opt/gitlab-ci-2-demo/Dockerfile && docker images | grep -q "gitlab-ci-demo"
