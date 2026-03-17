# Шаг 9: Итоговое задание

Проектируем и создаём полноценную namespace-структуру для микросервисного приложения.

## Задача

Создать изолированные окружения для приложения с двумя сервисами: `api` и `worker`.

## 1. Создаём namespace с квотами

```bash
cat > final-namespaces.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: final-dev
  labels:
    env: dev
    managed-by: kubectl
---
apiVersion: v1
kind: Namespace
metadata:
  name: final-prod
  labels:
    env: prod
    managed-by: kubectl
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: final-dev
spec:
  hard:
    pods: "15"
    deployments.apps: "10"
    services: "10"
    requests.cpu: "2"
    requests.memory: 2Gi
    limits.cpu: "4"
    limits.memory: 4Gi
---
apiVersion: v1
kind: LimitRange
metadata:
  name: dev-limitrange
  namespace: final-dev
spec:
  limits:
  - type: Container
    default:
      cpu: "200m"
      memory: "128Mi"
    defaultRequest:
      cpu: "100m"
      memory: "64Mi"
EOF
kubectl apply -f final-namespaces.yaml
```{{execute}}

## 2. Деплоим сервисы в dev

```bash
cat > final-services.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: final-dev
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
        tier: backend
    spec:
      containers:
      - name: api
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "100m"
            memory: "64Mi"
          limits:
            cpu: "200m"
            memory: "128Mi"
---
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: final-dev
spec:
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worker
  namespace: final-dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: worker
  template:
    metadata:
      labels:
        app: worker
        tier: backend
    spec:
      containers:
      - name: worker
        image: busybox
        command: ["sh", "-c", "while true; do echo 'working...'; sleep 10; done"]
        resources:
          requests:
            cpu: "50m"
            memory: "32Mi"
          limits:
            cpu: "100m"
            memory: "64Mi"
EOF
kubectl apply -f final-services.yaml
kubectl rollout status deployment/api -n final-dev
```{{execute}}

## 3. Проверяем изоляцию

```bash
# В final-prod — пусто
kubectl get all -n final-prod
```{{execute}}

```bash
# В final-dev — наши сервисы
kubectl get all -n final-dev
```{{execute}}

## 4. Смотрим квоту

```bash
kubectl describe resourcequota dev-quota -n final-dev
```{{execute}}

## 5. Переключаемся в dev и работаем без -n

```bash
kubectl config set-context --current --namespace=final-dev
kubectl get pods
kubectl get services
kubectl logs -l app=worker --tail=5
```{{execute}}

## 6. DNS-обращение из другого namespace

```bash
kubectl run cross-ns-test --image=curlimages/curl --rm -it --restart=Never   -n final-prod   -- curl -s http://api-svc.final-dev.svc.cluster.local/ | head -5
```{{execute}}

## 7. Возвращаемся и убираем

```bash
kubectl config set-context --current --namespace=default
kubectl delete namespace final-dev final-prod development staging production   team-backend team-frontend app-dev app-staging app-prod 2>/dev/null; true
echo "Готово!"
```{{execute}}
