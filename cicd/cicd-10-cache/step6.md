# Шаг 6: Собираем финальный cache-workflow

Теперь оформим итоговый workflow.

```bash
cat > /root/cicd_cache_final.yml <<'EOF'
name: cache-final

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
          cache: npm
      - uses: actions/cache@v4
        with:
          path: ~/.npm
          key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-npm-
      - run: npm ci
EOF

cat /root/cicd_cache_final.yml
```{{execute}}
