# Шаг 7: Собираем финальный batch-report

Соберите маленькую сводку по теме.

```bash
cat > /root/jobs_cronjobs_report.txt <<'EOF'
job=one_off_task
cronjob=scheduled_task
manual_run=create_job_from_cronjob
pause_mode=suspend_true
EOF

cat /root/jobs_cronjobs_report.txt
```{{execute}}
