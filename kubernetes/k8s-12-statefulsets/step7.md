# Шаг 7: Собираем отчёт по stateful workload

Сформулируйте ключевые свойства StatefulSet в коротком отчёте.

```bash
cat > /root/stateful_report.txt <<'EOF'
stable_names=yes
headless_service=yes
ordered_pods=yes
use_case=databases_and_clustered_apps
EOF

cat /root/stateful_report.txt
```{{execute}}
