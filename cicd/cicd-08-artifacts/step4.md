# Шаг 4: Добавляем download-artifact

Следующий job часто должен скачать артефакт из предыдущего.

```bash
cat > /root/cicd_artifacts_download.yml <<'EOF'
- name: Download build artifact
  uses: actions/download-artifact@v4
  with:
    name: release-files
    path: downloaded/
EOF

cat /root/cicd_artifacts_download.yml
```{{execute}}
