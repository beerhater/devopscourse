# Шаг 5: Скейлим обратно до 2 реплик

Теперь уменьшим число реплик и посмотрим, что StatefulSet делает это предсказуемо.

```bash
kubectl scale statefulset app-stateful --replicas=2
kubectl rollout status statefulset/app-stateful --timeout=120s
kubectl get pods -l app=app-headless -o name | sort > /root/stateful_scaled_back.txt
cat /root/stateful_scaled_back.txt
```{{execute}}
