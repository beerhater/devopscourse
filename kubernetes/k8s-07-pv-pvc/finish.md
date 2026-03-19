# Модуль завершён! 🎉

## Что изучили

- **PersistentVolume (PV)** — кластерный ресурс, описывает хранилище
- **PersistentVolumeClaim (PVC)** — запрос пода на хранилище
- **Статическое выделение** — администратор создаёт PV, PVC находит и связывается
- **Динамическое выделение** — StorageClass + provisioner создают PV автоматически
- **`hostPath`** — путь на узле, для разработки и тестирования
- **Access Modes** — `RWO` (один узел), `ROX` (много на чтение), `RWX` (много на запись)
- **Reclaim Policy** — `Retain` (данные остаются), `Delete` (PV удаляется вместе с PVC)
- **`emptyDir`** — временное хранилище на время жизни пода
- **Deployment + PVC** — стратегия `Recreate` обязательна при `RWO`
- **Binding** — правила совпадения storageClassName, accessModes, capacity

## Шпаргалка

```bash
# PV и PVC
kubectl get pv
kubectl get pvc
kubectl describe pv NAME
kubectl describe pvc NAME

# StorageClass
kubectl get storageclass

# Освободить Retain PV
kubectl patch pv NAME --type=json \
  -p='[{"op":"remove","path":"/spec/claimRef"}]'

# Размер хранилища в поде
kubectl exec POD -- df -h /mount/path
```

## Следующий модуль

**Ingress** — умный HTTP/HTTPS роутинг: один IP, много сервисов по доменам и путям.
