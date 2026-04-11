# Шаг 3: Настраиваем retention-days

Для артефактов часто задают срок хранения.

```bash
cat > /root/cicd_artifacts_retention.yml <<'EOF'
- uses: actions/upload-artifact@v4
  with:
    name: release-files
    path: dist/
    retention-days: 7
EOF

cat /root/cicd_artifacts_retention.yml
```{{execute}}
