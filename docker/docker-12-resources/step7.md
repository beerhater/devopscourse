# Шаг 7: Формулируем рекомендации по лимитам

Сделайте себе короткую памятку, что именно вы ограничили и зачем.

```bash
cat > /root/resource_recommendation.txt <<'EOF'
memory_limit=protect_host_from_oom
cpu_limit=avoid_noisy_neighbor
pids_limit=protect_from_fork_bombs
nofile_limit=control_open_files
EOF

cat /root/resource_recommendation.txt
```{{execute}}
