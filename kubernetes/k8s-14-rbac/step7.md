# Шаг 7: Собираем least-privilege report

Сделайте короткую памятку по смыслу RBAC в этом упражнении.

```bash
cat > /root/rbac_report.txt <<'EOF'
viewer_can_get_pods=yes
viewer_can_delete_pods=no
viewer_can_get_configmaps=yes
principle=least_privilege
EOF

cat /root/rbac_report.txt
```{{execute}}
