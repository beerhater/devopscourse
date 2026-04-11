# Шаг 3: Запускаем Job вручную из CronJob

Иногда CronJob нужно проверить руками, не дожидаясь расписания.

```bash
kubectl delete job report-manual --ignore-not-found
kubectl create job --from=cronjob/report-cron report-manual
kubectl get jobs report-manual -o wide > /root/manual_job_status.txt
cat /root/manual_job_status.txt
```{{execute}}
