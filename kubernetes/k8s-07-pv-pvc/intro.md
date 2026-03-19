# PersistentVolume и PVC — хранение данных в кластере

Контейнеры stateless: при перезапуске пода все данные внутри контейнера пропадают.
**PersistentVolume (PV)** — кусок хранилища в кластере. **PersistentVolumeClaim (PVC)** — запрос на это хранилище от пода.

## Цепочка

```
Pod → PVC (запрос) → PV (хранилище) → Диск / NFS / Cloud-volume
```

## Что изучим

- Почему данные теряются без PV
- Статическое выделение: создать PV вручную → привязать PVC
- Динамическое выделение: StorageClass сам создаёт PV
- Режимы доступа: `ReadWriteOnce`, `ReadOnlyMany`, `ReadWriteMany`
- Reclaim Policy: `Retain` vs `Delete`
- `hostPath` — для разработки и экспериментов
- Deployment + PVC — паттерн stateful-приложения

> Смотрим узлы: `kubectl get nodes`{{execute}}
