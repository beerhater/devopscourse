# Шаг 9: Итоговое задание

Создаём реалистичную архитектуру: **backend** (ClusterIP) + **frontend** (NodePort) + проверяем маршрутизацию.

## 1. Backend — доступен только внутри кластера

```bash
cat > backend.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: api
        image: hashicorp/http-echo:alpine
        args: ["-text=Hello from Backend API", "-listen=:5678"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
spec:
  type: ClusterIP       # Только внутренний доступ
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 5678
EOF
kubectl apply -f backend.yaml
kubectl rollout status deployment/backend
```{{execute}}

## 2. Frontend — NodePort для внешнего доступа

```bash
cat > frontend.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: web
        image: nginx:alpine
        ports:
        - containerPort: 80
        command: ["/bin/sh", "-c"]
        args:
        - |
          echo 'server { listen 80; location / { proxy_pass http://backend-svc; } }'             > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30090
EOF
kubectl apply -f frontend.yaml
kubectl rollout status deployment/frontend
```{{execute}}

## 3. Проверяем связь

```bash
kubectl get services
kubectl get endpoints
```{{execute}}

```bash
# Frontend → Backend через ClusterIP (внутри кластера)
kubectl run test-client --image=curlimages/curl --rm -it --restart=Never   -- curl -s http://backend-svc/
```{{execute}}

```bash
# Внешний доступ через NodePort
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl -s http://$NODE_IP:30090/
```{{execute}}

## 4. Смотрим итоговую картину

```bash
kubectl get all -l 'app in (backend, frontend)'
```{{execute}}

```bash
kubectl describe service backend-svc
kubectl describe service frontend-svc
```{{execute}}

## 5. Очистка

```bash
kubectl delete -f backend.yaml -f frontend.yaml
kubectl delete service demo-svc demo-svc-yaml demo-nodeport demo-nodeport-auto 2>/dev/null; true
kubectl delete deployment demo-app 2>/dev/null; true
echo "Готово!"
```{{execute}}
