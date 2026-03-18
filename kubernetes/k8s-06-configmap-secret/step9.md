# Шаг 9: Итоговое задание

Собираем всё вместе: приложение которое читает конфиг из ConfigMap и секреты из Secret.

## 1. Создаём полную конфигурацию

```bash
cat > final-config.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: final-app-config
data:
  APP_ENV: "production"
  APP_PORT: "8080"
  LOG_LEVEL: "warn"
  REDIS_HOST: "redis.default.svc.cluster.local"
  REDIS_PORT: "6379"
  server.conf: |
    port=8080
    workers=4
    timeout=30
    max_connections=1000
---
apiVersion: v1
kind: Secret
metadata:
  name: final-app-secret
type: Opaque
stringData:
  DB_PASSWORD: "prod-db-password-2026"
  JWT_SECRET: "jwt-signing-key-super-secret"
  REDIS_PASSWORD: "redis-auth-token"
EOF
kubectl apply -f final-config.yaml
```{{execute}}

## 2. Deployment использующий и CM и Secret

```bash
cat > final-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: final-app
  annotations:
    config-hash: "placeholder"   # Будем обновлять при смене конфига
spec:
  replicas: 2
  selector:
    matchLabels:
      app: final-app
  template:
    metadata:
      labels:
        app: final-app
    spec:
      volumes:
      - name: app-config-vol
        configMap:
          name: final-app-config
          items:
          - key: server.conf
            path: server.conf
      - name: app-secrets-vol
        secret:
          secretName: final-app-secret
          defaultMode: 0400
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
        envFrom:
        - configMapRef:
            name: final-app-config
        env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: final-app-secret
              key: DB_PASSWORD
        - name: JWT_SECRET
          valueFrom:
            secretKeyRef:
              name: final-app-secret
              key: JWT_SECRET
        volumeMounts:
        - name: app-config-vol
          mountPath: /etc/app
          readOnly: true
        - name: app-secrets-vol
          mountPath: /etc/secrets
          readOnly: true
        resources:
          requests:
            cpu: "50m"
            memory: "32Mi"
          limits:
            cpu: "100m"
            memory: "64Mi"
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 5
EOF
kubectl apply -f final-deployment.yaml
kubectl rollout status deployment/final-app
```{{execute}}

## 3. Проверяем конфигурацию в поде

```bash
POD=$(kubectl get pods -l app=final-app -o jsonpath='{.items[0].metadata.name}')
echo "Pod: $POD"
```{{execute}}

```bash
# Переменные окружения из CM
kubectl exec $POD -- env | grep -E '^APP_|^LOG_|^REDIS_'
```{{execute}}

```bash
# Секреты тоже передались
kubectl exec $POD -- env | grep -E '^DB_|^JWT_'
```{{execute}}

```bash
# Файл конфига примонтирован
kubectl exec $POD -- cat /etc/app/server.conf
```{{execute}}

```bash
# Файлы секретов примонтированы с ограниченными правами
kubectl exec $POD -- ls -la /etc/secrets/
```{{execute}}

## 4. Обновляем конфиг — rolling update

```bash
# Меняем LOG_LEVEL
kubectl create configmap final-app-config   --from-literal=APP_ENV=production   --from-literal=APP_PORT=8080   --from-literal=LOG_LEVEL=debug   --from-literal=REDIS_HOST="redis.default.svc.cluster.local"   --from-literal=REDIS_PORT=6379   --dry-run=client -o yaml | kubectl apply -f -

# Принудительный рестарт подов (env не обновляется автоматически)
kubectl rollout restart deployment/final-app
kubectl rollout status deployment/final-app
```{{execute}}

```bash
# Новый под — новый LOG_LEVEL
NEW_POD=$(kubectl get pods -l app=final-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec $NEW_POD -- env | grep LOG_LEVEL
```{{execute}}

## 5. Очистка

```bash
kubectl delete deployment final-app nginx-configured config-app
kubectl delete configmap app-config app-properties nginx-configs web-config   live-config final-app-config app-version-config nginx-custom-config 2>/dev/null; true
kubectl delete secret db-credentials api-credentials myapp-tls   nginx-auth final-app-secret registry-creds immutable-creds 2>/dev/null; true
kubectl delete pod app-volume-demo app-secret-volume live-update-demo 2>/dev/null; true
echo "Готово!"
```{{execute}}
