# Шаг 3: Пример cache для Python

Похожий паттерн легко переносится и на другие экосистемы.

```bash
cat > /root/cicd_cache_python.yml <<'EOF'
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
EOF

cat /root/cicd_cache_python.yml
```{{execute}}
