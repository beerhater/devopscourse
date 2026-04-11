# Шаг 2: Добавляем restore-keys

`restore-keys` помогает частично попасть в кеш, даже если основной ключ изменился.

```bash
cat > /root/cicd_cache_restore.yml <<'EOF'
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-
EOF

cat /root/cicd_cache_restore.yml
```{{execute}}
