# Шаг 6: Настраиваем history limits

Чтобы не копить бесконечную историю, CronJob обычно ограничивают по количеству старых job.

```bash
kubectl patch cronjob report-cron -p '{"spec":{"successfulJobsHistoryLimit":1,"failedJobsHistoryLimit":1}}'
kubectl get cronjob report-cron -o jsonpath='{.spec.successfulJobsHistoryLimit} {.spec.failedJobsHistoryLimit}' > /root/cronjob_history_limits.txt
cat /root/cronjob_history_limits.txt
```{{execute}}
