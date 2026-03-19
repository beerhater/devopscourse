# Shag 8: Realnyj primer — polnoe prilozhenie

```bash
cat > full-app.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-frontend
  template:
    metadata:
      labels:
        app: web-frontend
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: web-frontend-svc
spec:
  selector:
    app: web-frontend
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-backend
  template:
    metadata:
      labels:
        app: web-backend
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: web-backend-svc
spec:
  selector:
    app: web-backend
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-admin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-admin
  template:
    metadata:
      labels:
        app: web-admin
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: web-admin-svc
spec:
  selector:
    app: web-admin
  ports:
  - port: 80
EOF
kubectl apply -f full-app.yaml
kubectl rollout status deployment/web-frontend --timeout=60s
kubectl rollout status deployment/web-backend  --timeout=60s
kubectl rollout status deployment/web-admin    --timeout=60s
```{{execute}}

```bash
cat > app-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60"
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  ingressClassName: nginx
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: web-backend-svc
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-frontend-svc
            port:
              number: 80
  - host: admin.myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-admin-svc
            port:
              number: 80
EOF
kubectl apply -f app-ingress.yaml
kubectl get ingress app-ingress
```{{execute}}

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
grep -q 'admin.myapp.local' /etc/hosts || echo "$NODE_IP admin.myapp.local" >> /etc/hosts

HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

echo "=== myapp.local / -> frontend ==="
curl -s http://myapp.local:$HTTP_PORT/ | grep -o '<title>.*</title>'
echo "=== myapp.local/api -> backend ==="
curl -s http://myapp.local:$HTTP_PORT/api | grep -o '<title>.*</title>'
echo "=== admin.myapp.local -> admin ==="
curl -s http://admin.myapp.local:$HTTP_PORT/ | grep -o '<title>.*</title>'
```{{execute}}

```bash
kubectl describe ingress app-ingress
```{{execute}}
