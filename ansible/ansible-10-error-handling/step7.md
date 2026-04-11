# Шаг 7: Формируем error-handling checklist

```bash
cat > /root/ansible_error_checklist.txt <<'EOF'
failed_when_for_semantic_failures=yes
ignore_errors_only_when_safe=yes
use_rescue_for_controlled_recovery=yes
use_changed_when_for_checks=yes
EOF

cat /root/ansible_error_checklist.txt
```{{execute}}
