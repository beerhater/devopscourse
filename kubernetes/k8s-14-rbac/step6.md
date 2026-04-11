# Шаг 6: Смотрим ServiceAccount как объект

`ServiceAccount` тоже полезно читать как обычный Kubernetes-ресурс.

```bash
kubectl get sa viewer -o yaml > /root/rbac_serviceaccount.yaml
cat /root/rbac_serviceaccount.yaml
```{{execute}}
