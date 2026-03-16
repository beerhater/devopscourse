#!/bin/bash
test -f /opt/final-gitlab-ci/.gitlab-ci.yml && python3 -c "import yaml; yaml.safe_load(open('/opt/final-gitlab-ci/.gitlab-ci.yml'))" 2>/dev/null && grep -q "artifacts:" /opt/final-gitlab-ci/.gitlab-ci.yml && grep -q "after_script:" /opt/final-gitlab-ci/.gitlab-ci.yml
