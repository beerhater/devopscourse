#!/bin/bash
test -f /opt/gitlab-ci-2-demo/registry-auth-demo.gitlab-ci.yml && docker ps | grep -q "local-registry"
