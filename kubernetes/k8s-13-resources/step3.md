# Шаг 3: Проверяем QoS класс Burstable

Так как `requests` и `limits` у pod разные, QoS класс должен быть `Burstable`.

```bash
kubectl get pod resource-demo -o jsonpath='{.status.qosClass}' > /root/resource_qos.txt
cat /root/resource_qos.txt
```{{execute}}
