# Шаг 1: kubectl run — запуск пода

```bash
kubectl run my-nginx --image=nginx
```{{execute}}

```bash
kubectl get pods -w
```{{execute}}

Нажмите `Ctrl+C` когда увидите статус `Running`.

## Что значат колонки

```bash
kubectl get pods -o wide
```{{execute}}

| Колонка | Описание |
|---------|----------|
| `READY` | Готовых/всего контейнеров (1/1 = норма) |
| `STATUS` | Текущий статус |
| `RESTARTS` | Сколько раз перезапускался |
| `NODE` | На каком узле |
| `IP` | IP внутри кластера |

```bash
kubectl run busybox --image=busybox -- sleep 3600
kubectl get pods
```{{execute}}
