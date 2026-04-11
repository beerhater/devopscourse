# Шаг 1: Создаём Job и CronJob

Создайте одноразовую задачу и отдельную задачу по расписанию.

```bash
cat > /root/jobs-demo.yaml <<'EOF'
apiVersion: batch/v1
kind: Job
metadata:
  name: report-job
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: runner
          image: busybox:1.36
          command: ["sh", "-c", "echo report-ready > /tmp/report && cat /tmp/report"]
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: report-cron
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: runner
              image: busybox:1.36
              command: ["sh", "-c", "date && echo cron-report"]
EOF

kubectl apply -f /root/jobs-demo.yaml
kubectl get job report-job -o wide > /root/jobs_status.txt
kubectl get cronjob report-cron -o wide > /root/cronjobs_status.txt

cat /root/jobs_status.txt
cat /root/cronjobs_status.txt
```{{execute}}

Такой шаблон пригодится для:

- backup;
- cleanup;
- миграций базы;
- периодических health-check задач.
