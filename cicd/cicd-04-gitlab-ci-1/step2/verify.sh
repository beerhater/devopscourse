#!/bin/bash
test -f /opt/gitlab-ci-demo/.gitlab-ci.yml && python3 -c "import yaml; yaml.safe_load(open('/opt/gitlab-ci-demo/.gitlab-ci.yml'))" 2>/dev/null && grep -q "stages:" /opt/gitlab-ci-demo/.gitlab-ci.yml
