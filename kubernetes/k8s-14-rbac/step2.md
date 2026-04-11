# Шаг 2: Смотрим YAML роли

Перед изменениями полезно увидеть текущую роль целиком.

```bash
kubectl get role pod-reader -o yaml > /root/rbac_role.yaml
cat /root/rbac_role.yaml
```{{execute}}
