# Шаг 5: Проверяем subject и roleRef в RoleBinding

Важно понимать, кто именно связан с какой ролью.

```bash
kubectl get rolebinding pod-reader-binding -o jsonpath='{.subjects[0].name} {.roleRef.name}' > /root/rbac_binding_details.txt
cat /root/rbac_binding_details.txt
```{{execute}}
