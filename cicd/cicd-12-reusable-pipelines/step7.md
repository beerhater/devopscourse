# Шаг 7: Формируем reusable-checklist

```bash
cat > /root/reusable_checklist.txt <<'EOF'
avoid_copy_paste=yes
use_inputs=yes
use_outputs_when_needed=yes
inherit_secrets_carefully=yes
EOF

cat /root/reusable_checklist.txt
```{{execute}}
