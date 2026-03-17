# Шаг 3: Deployment YAML — анатомия манифеста

Посмотрим на полный YAML нашего Deployment:

```bash
kubectl get deployment my-nginx -o yaml
```{{execute}}

Много полей — но нас интересуют ключевые. Создадим Deployment из манифеста вручную:

```bash
cat > web-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
    team: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app        # Deployment управляет подами с этим label
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1         # Можно запустить на 1 под БОЛЬШЕ нормы при обновлении
      maxUnavailable: 0   # Нельзя убивать поды до старта новых (нулевой downtime)
  template:               # Шаблон пода — всё что ниже создаётся для каждой реплики
    metadata:
      labels:
        app: web-app      # Должен совпадать с selector.matchLabels!
        version: v1
    spec:
      containers:
      - name: nginx
        image: nginx:1.24-alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "32Mi"
            cpu: "50m"
          limits:
            memory: "64Mi"
            cpu: "100m"
        readinessProbe:             # K8s проверяет готовность ДО пуска трафика
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        livenessProbe:              # K8s перезапускает если этот check падает
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
EOF
kubectl apply -f web-deployment.yaml
```{{execute}}

```bash
kubectl get deployment web-app
kubectl get pods -l app=web-app
```{{execute}}

## Ключевые поля

| Поле | Описание |
|------|----------|
| `spec.replicas` | Нужное число подов |
| `spec.selector.matchLabels` | По каким label Deployment ищет свои поды |
| `spec.template` | Шаблон пода — точно такой же `spec` как у Pod |
| `spec.strategy` | Стратегия обновления |
| `readinessProbe` | Под получает трафик только после успешной проверки |
| `livenessProbe` | Под перезапускается если проверка падает |
