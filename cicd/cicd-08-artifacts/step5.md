# Шаг 5: Упаковываем несколько файлов

Иногда artifact должен содержать сразу несколько результатов сборки.

```bash
cat > /root/cicd_artifacts_multi.yml <<'EOF'
- uses: actions/upload-artifact@v4
  with:
    name: release-bundle
    path: |
      dist/
      reports/
EOF

cat /root/cicd_artifacts_multi.yml
```{{execute}}
