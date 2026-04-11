# Шаг 5: Сравниваем два подхода

Сведите вручную configured cache patterns в одну заметку.

```bash
cat > /root/cicd_cache_compare.txt <<'EOF'
actions_cache=flexible_custom_paths
setup_node_cache=simple_for_npm
restore_keys=good_for_partial_hits
EOF

cat /root/cicd_cache_compare.txt
```{{execute}}
