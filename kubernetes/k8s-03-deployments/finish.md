# Модуль завершён! 🎉

## Что изучили

- **`kubectl create deployment`** — создать Deployment императивно
- **`spec.replicas`** — нужное число Pod-реплик, self-healing
- **`kubectl scale`** — изменить число реплик на лету
- **`kubectl set image`** — обновить образ без правки YAML
- **`RollingUpdate`** — замена подов по одному, нулевой downtime
- **`Recreate`** — все поды убиваются перед созданием новых
- **`maxSurge / maxUnavailable`** — контроль скорости и надёжности обновления
- **`readinessProbe / livenessProbe`** — защита от плохого деплоя
- **`kubectl rollout status/history/undo/pause/resume`** — полный контроль над обновлением
- **ReplicaSet** — промежуточный объект между Deployment и Pod
- **CI/CD паттерн** — `set image` → `rollout status` → `rollout undo` при ошибке

## Шпаргалка

```bash
# Создание
kubectl create deployment NAME --image=IMG --replicas=3
kubectl apply -f deployment.yaml

# Масштабирование
kubectl scale deployment NAME --replicas=5

# Обновление
kubectl set image deployment/NAME container=IMG:TAG
kubectl rollout status deployment/NAME
kubectl rollout history deployment/NAME
kubectl rollout undo deployment/NAME
kubectl rollout undo deployment/NAME --to-revision=2

# Диагностика
kubectl get deployment NAME
kubectl describe deployment NAME
kubectl get replicasets -l app=NAME
```

## Следующий модуль

**Service** — как дать стабильный сетевой адрес для доступа к подам снаружи и изнутри кластера.
