# Шаг 7: Формируем handlers-checklist

```bash
cat > /root/ansible_handlers_checklist.txt <<'EOF'
notify_only_on_change=yes
handler_runs_once=yes
flush_handlers_when_needed=yes
templates_often_notify_handlers=yes
EOF

cat /root/ansible_handlers_checklist.txt
```{{execute}}
