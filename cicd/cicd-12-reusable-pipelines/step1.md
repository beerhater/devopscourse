# Шаг 1: Создаём reusable workflow и вызов

Создайте reusable workflow и отдельный caller workflow.

```bash
mkdir -p /root/cicd-reusable/.github/workflows

cat > /root/cicd-reusable/.github/workflows/common-test.yml <<'EOF'
name: reusable-test

on:
  workflow_call:
    inputs:
      app-name:
        required: true
        type: string

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Running common checks for ${{ inputs.app-name }}"
EOF

cat > /root/cicd-reusable/.github/workflows/caller.yml <<'EOF'
name: caller

on:
  push:
    branches: [main]

jobs:
  call-common:
    uses: ./.github/workflows/common-test.yml
    with:
      app-name: payments-api
EOF

cp /root/cicd-reusable/.github/workflows/common-test.yml /root/reusable_common.yml
cp /root/cicd-reusable/.github/workflows/caller.yml /root/reusable_caller.yml

cat /root/reusable_caller.yml
```{{execute}}

Это хорошая основа для единых quality gates в нескольких сервисах.
