# Шаг 7: Формулируем практические рекомендации

Соберите для себя короткую памятку по requests/limits.

```bash
cat > /root/k8s_resource_recommendation.txt <<'EOF'
requests=for_scheduling
limits=for_runtime_boundaries
burstable=when_requests_and_limits_differ
guaranteed=when_requests_equal_limits
EOF

cat /root/k8s_resource_recommendation.txt
```{{execute}}
