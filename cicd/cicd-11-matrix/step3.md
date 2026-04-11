# Шаг 3: Используем include

`include` помогает добавить особый кейс поверх основной сетки.

```bash
cat > /root/cicd_matrix_include.yml <<'EOF'
strategy:
  matrix:
    node: [18, 20]
    include:
      - node: 22
        experimental: true
EOF

cat /root/cicd_matrix_include.yml
```{{execute}}
