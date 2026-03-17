# Шаг 7: Readiness и Liveness пробы — защита от плохих деплоев

Пробы — главный механизм защиты Rolling Update. Без них K8s не знает когда под реально готов.

## Демонстрация: деплой с багом БЕЗ readinessProbe

```bash
# Приложение которое падает через 10 секунд после старта
cat > buggy-app.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: buggy-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: buggy-app
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: buggy-app
    spec:
      containers:
      - name: app
        image: busybox
        command: ["sh", "-c", "echo 'Started' && sleep 5 && echo 'Crash!' && exit 1"]
EOF
kubectl apply -f buggy-app.yaml
```{{execute}}

```bash
sleep 8 && kubectl get pods -l app=buggy-app
```{{execute}}

```bash
# Поды в CrashLoopBackOff — но без readinessProbe деплой считается успешным!
kubectl rollout status deployment/buggy-app --timeout=15s || true
```{{execute}}

## Деплой с readinessProbe — защита включена

```bash
cat > safe-app.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: safe-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: safe-app
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: safe-app
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 3
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
          failureThreshold: 3
EOF
kubectl apply -f safe-app.yaml
kubectl rollout status deployment/safe-app
```{{execute}}

```bash
kubectl get pods -l app=safe-app
```{{execute}}

```bash
# Обновляем на несуществующий образ — Rolling Update ЗАМОРОЗИТСЯ
kubectl set image deployment/safe-app nginx=nginx:999-nonexistent
sleep 15
kubectl get pods -l app=safe-app
```{{execute}}

```bash
# Видим: новые поды в ImagePullBackOff, старые работают — продакшн НЕ пострадал
kubectl rollout status deployment/safe-app --timeout=5s || echo "Rollout завис — старые поды живы!"
```{{execute}}

```bash
# Откатываемся — всё мгновенно
kubectl rollout undo deployment/safe-app
kubectl rollout status deployment/safe-app
```{{execute}}

**Вывод**: `readinessProbe` + `maxUnavailable=0` = гарантированная защита от плохого деплоя.

```bash
kubectl delete deployment buggy-app
```{{execute}}
