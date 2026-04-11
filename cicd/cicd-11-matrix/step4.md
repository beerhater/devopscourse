# Шаг 4: Используем exclude

Если часть комбинаций невалидна, их лучше исключить явно.

```bash
cat > /root/cicd_matrix_exclude.yml <<'EOF'
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest]
    node: [18, 20]
    exclude:
      - os: windows-latest
        node: 18
EOF

cat /root/cicd_matrix_exclude.yml
```{{execute}}
