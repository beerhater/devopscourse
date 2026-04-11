# Шаг 5: Читаем логи краша

У CrashLoopBackOff часто главный ответ скрыт именно в логах контейнера.

```bash
kubectl logs crash-demo --previous > /root/crash_logs.txt 2>&1 || kubectl logs crash-demo > /root/crash_logs.txt 2>&1
cat /root/crash_logs.txt
```{{execute}}
