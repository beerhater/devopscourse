# Шаг 2: Читаем логи завершившегося Job

У `Job` результат часто виден именно в логах.

```bash
kubectl wait --for=condition=Complete job/report-job --timeout=120s
kubectl logs job/report-job > /root/job_report_logs.txt
cat /root/job_report_logs.txt
```{{execute}}

Это удобно для одноразовых задач вроде миграций, backup и generation jobs.
