# Шаг 5: Настраиваем fail-fast и max-parallel

Иногда хочется не останавливать все ветки matrix при первой ошибке.

```bash
cat > /root/cicd_matrix_parallel.yml <<'EOF'
strategy:
  fail-fast: false
  max-parallel: 2
  matrix:
    node: [18, 20]
EOF

cat /root/cicd_matrix_parallel.yml
```{{execute}}
