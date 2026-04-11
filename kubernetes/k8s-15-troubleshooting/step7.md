# Шаг 7: Собираем troubleshooting-checklist

Сделайте себе короткую памятку по первому разбору проблемного pod.

```bash
cat > /root/k8s_troubleshooting_checklist.txt <<'EOF'
1_check_describe=yes
2_check_events=yes
3_check_logs=yes
4_compare_waiting_reason=yes
EOF

cat /root/k8s_troubleshooting_checklist.txt
```{{execute}}
