# Шаг 5: Возвращаем CronJob в работу

Теперь вернём расписание обратно.

```bash
kubectl patch cronjob report-cron -p '{"spec":{"suspend":false}}'
kubectl get cronjob report-cron -o jsonpath='{.spec.suspend}' > /root/cronjob_resumed.txt
cat /root/cronjob_resumed.txt
```{{execute}}
