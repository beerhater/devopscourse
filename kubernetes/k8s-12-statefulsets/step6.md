# Шаг 6: Делаем rollout restart

Даже stateful workload иногда нужно аккуратно перезапустить.

```bash
kubectl rollout restart statefulset/app-stateful
kubectl rollout status statefulset/app-stateful --timeout=120s
kubectl get statefulset app-stateful -o jsonpath='{.status.readyReplicas}' > /root/stateful_restart_ready.txt
cat /root/stateful_restart_ready.txt
```{{execute}}
