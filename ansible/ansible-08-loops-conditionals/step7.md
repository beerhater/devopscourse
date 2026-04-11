# Шаг 7: Формируем loops-checklist

```bash
cat > /root/ansible_loops_checklist.txt <<'EOF'
loop_for_repetition=yes
when_for_conditions=yes
loop_control_for_readable_output=yes
combine_loop_and_when_carefully=yes
EOF

cat /root/ansible_loops_checklist.txt
```{{execute}}
