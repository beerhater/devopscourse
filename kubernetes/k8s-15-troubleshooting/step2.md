# Шаг 2: Читаем причину через jsonpath

Для быстрой диагностики удобно вытащить причину ожидания контейнера одной строкой.

```bash
kubectl get pod broken-demo -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}' > /root/broken_reason_jsonpath.txt
cat /root/broken_reason_jsonpath.txt
```{{execute}}
