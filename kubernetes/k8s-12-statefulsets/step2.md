# Шаг 2: Масштабируем StatefulSet до 3 реплик

У stateful workloads важно, что реплики получают стабильные ordinals.

```bash
kubectl scale statefulset app-stateful --replicas=3
kubectl rollout status statefulset/app-stateful --timeout=120s
kubectl get pods -l app=app-headless -o name | sort > /root/stateful_scaled_pods.txt
cat /root/stateful_scaled_pods.txt
```{{execute}}
