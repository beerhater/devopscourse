# Шаг 6: Именуем артефакты по matrix-параметрам

Если matrix генерирует артефакты, их полезно именовать по параметрам.

```bash
cat > /root/cicd_matrix_artifacts.yml <<'EOF'
- uses: actions/upload-artifact@v4
  with:
    name: build-${{ matrix.node }}
    path: dist/
EOF

cat /root/cicd_matrix_artifacts.yml
```{{execute}}
