# Шаг 9: Итоговое задание

Применяем всё изученное: создаём полный Deployment с нуля, масштабируем, обновляем, откатываем.

## 1. Создайте Deployment из манифеста

```bash
cat > final-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: final-web
  labels:
    app: final-web
    env: practice
  annotations:
    kubernetes.io/change-cause: "initial deploy nginx:1.24-alpine"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: final-web
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: final-web
        version: v1
    spec:
      containers:
      - name: web
        image: nginx:1.24-alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "16Mi"
            cpu: "25m"
          limits:
            memory: "32Mi"
            cpu: "50m"
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 3
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
EOF
kubectl apply -f final-deployment.yaml
kubectl rollout status deployment/final-web
```{{execute}}

## 2. Проверьте состояние

```bash
kubectl get deployment final-web
kubectl get pods -l app=final-web -o wide
kubectl get replicasets -l app=final-web
```{{execute}}

## 3. Масштабируйте до 5 реплик

```bash
kubectl scale deployment final-web --replicas=5
kubectl get pods -l app=final-web -w
```{{execute}}

Нажмите `Ctrl+C`.

## 4. Обновите образ (Rolling Update)

```bash
kubectl set image deployment/final-web web=nginx:1.25-alpine
kubectl annotate deployment/final-web kubernetes.io/change-cause="update to 1.25-alpine" --overwrite
kubectl rollout status deployment/final-web
```{{execute}}

```bash
kubectl get replicasets -l app=final-web
```{{execute}}

## 5. Ещё одно обновление

```bash
kubectl set image deployment/final-web web=nginx:1.26-alpine
kubectl annotate deployment/final-web kubernetes.io/change-cause="update to 1.26-alpine" --overwrite
kubectl rollout status deployment/final-web
```{{execute}}

## 6. Посмотрите историю и откатитесь

```bash
kubectl rollout history deployment/final-web
```{{execute}}

```bash
# Откат на первую версию
kubectl rollout undo deployment/final-web --to-revision=1
kubectl rollout status deployment/final-web
```{{execute}}

```bash
kubectl get deployment final-web -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{execute}}

## 7. Масштабируйте вниз и опишите Deployment

```bash
kubectl scale deployment final-web --replicas=2
kubectl describe deployment final-web
```{{execute}}

## 8. Очистка

```bash
kubectl delete deployment final-web web-app my-nginx safe-app 2>/dev/null; true
```{{execute}}
