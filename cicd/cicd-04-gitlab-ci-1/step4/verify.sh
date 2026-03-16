#!/bin/bash
test -f /opt/gitlab-ci-demo/jobs-anatomy.gitlab-ci.yml && grep -q "rules:" /opt/gitlab-ci-demo/jobs-anatomy.gitlab-ci.yml
