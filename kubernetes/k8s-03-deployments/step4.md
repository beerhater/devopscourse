# Шаг 4: Rolling Update — обновление без downtime

`RollingUpdate` — стратегия по умолчанию. Поды заменяются по одному: сначала стартует новый, потом убивается старый.

## Обновляем образ

```bash
# Текущая версия
kubectl get deployment web-app -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{execute}}

```bash
# Обновляем образ до 1.25-alpine
kubectl set image deployment/web-app nginx=nginx:1.25-alpine
```{{execute}}

```bash
# Наблюдаем как поды заменяются по одному
kubectl rollout status deployment/web-app
```{{execute}}

```bash
# Смотрим новые поды
kubectl get pods -l app=web-app
```{{execute}}

```bash
# Проверяем новую версию образа
kubectl get deployment web-app -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{execute}}

## Что происходит под капотом

Rolling Update создаёт **ReplicaSet** с новой версией и постепенно переносит поды:

```bash
kubectl get replicasets -l app=web-app
```{{execute}}

Видите два ReplicaSet? Старый (0 подов) и новый (3 пода). Старый сохраняется для возможности отката.

## maxSurge и maxUnavailable

```bash
# Обновим ещё раз и посмотрим на процесс подробно
kubectl set image deployment/web-app nginx=nginx:1.26-alpine
kubectl get pods -l app=web-app -w
```{{execute}}

Нажмите `Ctrl+C` когда все поды обновятся.

При `maxSurge=1, maxUnavailable=0`:
- Сначала создаётся 1 новый под (итого 4)
- После его Ready — убивается 1 старый (итого 3)
- Повторяется пока все не обновятся
- **В каждый момент работают все 3 реплики** → нулевой downtime
