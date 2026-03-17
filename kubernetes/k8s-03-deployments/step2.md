# Шаг 2: Replicas — несколько копий пода

```bash
kubectl get deployment my-nginx
```{{execute}}

Видите колонки: `READY`, `UP-TO-DATE`, `AVAILABLE`. Сейчас работает 1 реплика.

## Масштабируем до 4 реплик

```bash
kubectl scale deployment my-nginx --replicas=4
```{{execute}}

```bash
kubectl get pods -w
```{{execute}}

Нажмите `Ctrl+C` когда все 4 пода станут `Running`.

```bash
kubectl get pods -o wide
```{{execute}}

Обратите внимание — поды распределились по узлам (`controlplane` и `node01`).

## Что происходит при падении реплики

```bash
# Удаляем 2 пода одновременно
kubectl delete pod -l app=my-nginx --wait=false
sleep 1 && kubectl get pods
```{{execute}}

```bash
sleep 5 && kubectl get pods
```{{execute}}

Deployment мгновенно пересоздал удалённые поды. Всегда поддерживается нужное число реплик.

## Масштабируем вниз

```bash
kubectl scale deployment my-nginx --replicas=2
kubectl get pods
```{{execute}}
