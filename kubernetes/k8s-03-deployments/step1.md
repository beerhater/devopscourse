# Шаг 1: Зачем Deployment — демонстрация проблемы

Сначала увидим проблему голого Pod, затем решим её через Deployment.

## Проблема: Pod не восстанавливается

```bash
kubectl run naked-pod --image=nginx
```{{execute}}

```bash
kubectl get pods
```{{execute}}

```bash
# Удаляем под — он исчезает навсегда
kubectl delete pod naked-pod
kubectl get pods
```{{execute}}

Под пропал. В продакшене это означает downtime.

## Решение: Deployment следит за подами

```bash
kubectl create deployment my-nginx --image=nginx --replicas=1
```{{execute}}

```bash
kubectl get deployments
kubectl get pods
```{{execute}}

```bash
# Удаляем под — Deployment немедленно пересоздаёт его
POD=$(kubectl get pods -l app=my-nginx -o jsonpath='{.items[0].metadata.name}')
echo "Удаляем под: $POD"
kubectl delete pod $POD
```{{execute}}

```bash
# Под уже пересоздаётся или создан заново
sleep 3 && kubectl get pods
```{{execute}}

Deployment заметил что pod пропал и немедленно запустил новый. Это и есть **self-healing**.
