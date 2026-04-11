# Шаг 7: Формируем cache-checklist

```bash
cat > /root/cicd_cache_checklist.txt <<'EOF'
cache_dependencies=yes
stable_cache_key=yes
restore_keys=yes
avoid_caching_everything=yes
EOF

cat /root/cicd_cache_checklist.txt
```{{execute}}
