# Шаг 7: Собираем финальный cleanup-checklist

Сделайте короткую памятку по порядку безопасной уборки.

```bash
cat > /root/docker_cleanup_checklist.txt <<'EOF'
1_inspect_usage=docker_system_df
2_remove_stopped_containers=yes
3_remove_unused_networks=yes
4_remove_unused_volumes=yes
EOF

cat /root/docker_cleanup_checklist.txt
```{{execute}}
