# Шаг 7: Делаем artifact-checklist

Зафиксируйте для себя минимальный стандарт по артефактам.

```bash
cat > /root/cicd_artifacts_checklist.txt <<'EOF'
save_build_outputs=yes
save_test_reports=yes
set_retention=yes
download_between_jobs=yes
EOF

cat /root/cicd_artifacts_checklist.txt
```{{execute}}
