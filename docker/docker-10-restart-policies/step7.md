# Шаг 7: Выбираем policy под разные сценарии

Сформулируйте себе короткую памятку:

- что подходит для сервиса;
- что подходит для падающего job-like контейнера;
- что означает отсутствие policy.

```bash
cat > /root/restart_policy_recommendation.txt <<'EOF'
service=unless-stopped
crashing_worker=on-failure
no_policy=manual_control
EOF

cat /root/restart_policy_recommendation.txt
```{{execute}}
