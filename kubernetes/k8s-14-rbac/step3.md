# Шаг 3: Проверяем запрет на configmaps

Сейчас у service account нет прав на чтение `configmaps`.

```bash
kubectl auth can-i get configmaps --as=system:serviceaccount:default:viewer > /root/rbac_configmaps_before.txt
cat /root/rbac_configmaps_before.txt
```{{execute}}
