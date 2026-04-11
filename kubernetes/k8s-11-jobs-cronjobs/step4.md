# Шаг 4: Ставим CronJob на паузу

Полезный приём на production: временно остановить расписание без удаления объекта.

```bash
kubectl patch cronjob report-cron -p '{"spec":{"suspend":true}}'
kubectl get cronjob report-cron -o jsonpath='{.spec.suspend}' > /root/cronjob_suspended.txt
cat /root/cronjob_suspended.txt
```{{execute}}
