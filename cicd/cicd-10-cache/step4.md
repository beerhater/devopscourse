# Шаг 4: Используем built-in cache setup-node

Для Node.js можно включить кеш прямо через `setup-node`.

```bash
cat > /root/cicd_cache_setup_node.yml <<'EOF'
- uses: actions/setup-node@v4
  with:
    node-version: 20
    cache: npm
EOF

cat /root/cicd_cache_setup_node.yml
```{{execute}}
