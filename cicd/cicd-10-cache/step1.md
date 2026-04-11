# Шаг 1: Настраиваем cache в workflow

Создайте workflow с кешем для npm-зависимостей.

```bash
mkdir -p /root/cicd-cache/.github/workflows

cat > /root/cicd-cache/.github/workflows/cache.yml <<'EOF'
name: cache-demo

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - uses: actions/cache@v4
        with:
          path: ~/.npm
          key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-npm-
      - run: npm ci
      - run: npm test
EOF

cp /root/cicd-cache/.github/workflows/cache.yml /root/cicd_cache_result.yml
cat /root/cicd_cache_result.yml
```{{execute}}

Кеш особенно заметно ускоряет повторные pipeline run.
