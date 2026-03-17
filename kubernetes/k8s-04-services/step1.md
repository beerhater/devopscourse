# Шаг 1: Проблема — IP пода непостоянен

Покажем почему нельзя обращаться к поду напрямую по IP.

```bash
# Создаём тестовый Deployment
kubectl create deployment demo-app --image=nginx:alpine --replicas=3
kubectl rollout status deployment/demo-app
```{{execute}}

```bash
# Смотрим IP подов
kubectl get pods -l app=demo-app -o wide
```{{execute}}

```bash
# Запомним IP первого пода
POD=$(kubectl get pods -l app=demo-app -o jsonpath='{.items[0].metadata.name}')
OLD_IP=$(kubectl get pod $POD -o jsonpath='{.status.podIP}')
echo "Pod: $POD  IP: $OLD_IP"
```{{execute}}

```bash
# Убиваем под — Deployment создаёт новый с ДРУГИМ IP
kubectl delete pod $POD
sleep 5 && kubectl get pods -l app=demo-app -o wide
```{{execute}}

```bash
# Новый IP отличается — любой клиент потерял связь
NEW_POD=$(kubectl get pods -l app=demo-app -o jsonpath='{.items[0].metadata.name}')
NEW_IP=$(kubectl get pod $NEW_POD -o jsonpath='{.status.podIP}')
echo "Старый IP: $OLD_IP"
echo "Новый IP:  $NEW_IP"
```{{execute}}

Service решает эту проблему: он даёт **стабильный виртуальный IP** (ClusterIP) который не меняется, и сам следит за актуальными подами через `selector`.
