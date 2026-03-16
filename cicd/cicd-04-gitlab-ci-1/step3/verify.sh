#!/bin/bash
test -f /opt/gitlab-ci-demo/stages-demo.gitlab-ci.yml && grep -q "stage: .pre" /opt/gitlab-ci-demo/special-stages.gitlab-ci.yml
