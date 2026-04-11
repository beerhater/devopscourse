# Шаг 7: Формируем tags-checklist

```bash
cat > /root/ansible_tags_checklist.txt <<'EOF'
list_tags_before_targeted_run=yes
use_skip_tags_carefully=yes
group_related_tasks_under_clear_tags=yes
avoid_chaotic_tag_names=yes
EOF

cat /root/ansible_tags_checklist.txt
```{{execute}}
