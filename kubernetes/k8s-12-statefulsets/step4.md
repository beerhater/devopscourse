# Шаг 4: Разбираем headless service

Проверим, что сервис действительно headless и связан с StatefulSet.

```bash
kubectl get svc app-headless -o jsonpath='{.spec.clusterIP} {.spec.selector.app}' > /root/stateful_service_details.txt
cat /root/stateful_service_details.txt
```{{execute}}
