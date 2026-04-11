# Шаг 2: Расширяем matrix по ОС

Теперь добавим в matrix не только версии Node.js, но и ОС.

```bash
cat > /root/cicd_matrix_os.yml <<'EOF'
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
    node: [18, 20]
EOF

cat /root/cicd_matrix_os.yml
```{{execute}}
