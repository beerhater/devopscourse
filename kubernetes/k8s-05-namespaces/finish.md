# Модуль завершён! 🎉

## Что изучили

- **Namespace** — виртуальная изоляция ресурсов внутри одного кластера
- **Системные namespace** — `kube-system`, `kube-public`, `kube-node-lease`
- **`kubectl -n`** — работа с конкретным namespace
- **`kubectl -A / --all-namespaces`** — ресурсы всех namespace
- **`kubectl config set-context --current --namespace`** — сменить дефолтный namespace
- **Именованные контексты** — `kubectl config set-context / use-context`
- **Изоляция**: namespaced vs cluster-wide ресурсы
- **DNS между namespace** — `service.namespace.svc.cluster.local`
- **`ResourceQuota`** — лимиты ресурсов на namespace
- **`LimitRange`** — дефолтные request/limit для контейнеров
- **`NetworkPolicy`** — сетевая изоляция между namespace
- **`kubens` / алиасы** — быстрое переключение

## Шпаргалка

```bash
# Namespace
kubectl get namespaces
kubectl create namespace NAME
kubectl delete namespace NAME

# Работа в namespace
kubectl get pods -n NAME
kubectl get all -A

# Переключение
kubectl config set-context --current --namespace=NAME
kubectl config use-context CONTEXT_NAME

# Квоты и лимиты
kubectl get resourcequota -n NAME
kubectl describe limitrange -n NAME

# DNS внутри кластера
# <service>.<namespace>.svc.cluster.local
```

## Следующий модуль

**ConfigMap и Secret** — как передавать конфигурацию и секреты в поды без хардкода в образе.
