# Шаг 6: Собираем ресурсный отчёт по двум pod

Зафиксируем основные значения ресурсов для двух pod.

```bash
{
  echo "resource-demo $(kubectl get pod resource-demo -o jsonpath='{.spec.containers[0].resources.requests.cpu} {.spec.containers[0].resources.limits.memory}')"
  echo "guaranteed-demo $(kubectl get pod guaranteed-demo -o jsonpath='{.spec.containers[0].resources.requests.cpu} {.spec.containers[0].resources.limits.memory}')"
} > /root/k8s_resource_report.txt

cat /root/k8s_resource_report.txt
```{{execute}}
