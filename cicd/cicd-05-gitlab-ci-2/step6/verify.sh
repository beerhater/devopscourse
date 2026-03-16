#!/bin/bash
test -f /opt/gitlab-ci-2-demo/rules-demo.gitlab-ci.yml && grep -q "changes:" /opt/gitlab-ci-2-demo/rules-demo.gitlab-ci.yml && grep -q "exists:" /opt/gitlab-ci-2-demo/rules-demo.gitlab-ci.yml
