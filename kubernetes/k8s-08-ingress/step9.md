# Shag 9: Itogovoe zadanie

## 1. Sozdaem servisy

```bash
cat > final-services.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: final-frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: final-frontend
  template:
    metadata:
      labels:
        app: final-frontend
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
  name: final-frontend-svc
spec:
  selector:
    app: final-frontend
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: final-api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: final-api
  template:
    metadata:
      labels:
        app: final-api
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
  name: final-api-svc
spec:
  selector:
    app: final-api
  ports:
  - port: 80
EOF
kubectl apply -f final-services.yaml
kubectl rollout status deployment/final-frontend --timeout=60s
kubectl rollout status deployment/final-api      --timeout=60s
```{{execute}}

## 2. TLS Secret

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout final-tls.key -out final-tls.crt \
  -subj "/CN=final.local" 2>/dev/null
kubectl create secret tls final-tls-secret --cert=final-tls.crt --key=final-tls.key
echo "TLS Secret created"
```{{execute}}

## 3. Finalnyj Ingress

```bash
cat > final-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: final-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "30"
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
    nginx.ingress.kubernetes.io/limit-rps: "20"
    nginx.ingress.kubernetes.io/configuration-snippet: |
      add_header X-Frame-Options "SAMEORIGIN" always;
      add_header X-Content-Type-Options "nosniff" always;
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - final.local
    secretName: final-tls-secret
  rules:
  - host: final.local
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: final-api-svc
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: final-frontend-svc
            port:
              number: 80
EOF
kubectl apply -f final-ingress.yaml
kubectl get ingress final-ingress
```{{execute}}

## 4. Testiruem

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
grep -q 'final.local' /etc/hosts || echo "$NODE_IP final.local" >> /etc/hosts

HTTPS_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

echo "=== HTTPS / -> frontend ==="
curl -sk https://final.local:$HTTPS_PORT/ | grep -o '<title>.*</title>'
echo "=== HTTPS /api -> api ==="
curl -sk https://final.local:$HTTPS_PORT/api | grep -o '<title>.*</title>'
echo "=== HTTP -> redirect to HTTPS ==="
curl -si http://final.local:$HTTP_PORT/ | grep -E 'HTTP/|Location:' | head -3
```{{execute}}

## 5. Itogovoe sostoyanie

```bash
kubectl get ingress
kubectl get secrets | grep tls
```{{execute}}

## 6. Ochistka

```bash
kubectl delete ingress basic-ingress path-ingress host-ingress tls-ingress \
  rate-limit-ingress redirect-ingress cors-ingress app-ingress final-ingress 2>/dev/null; true
kubectl delete deployment frontend backend api frontend-v2 api-v2 admin-v2 \
  web-frontend web-backend web-admin final-frontend final-api 2>/dev/null; true
kubectl delete service frontend-svc backend-svc api-svc \
  frontend-v2-svc api-v2-svc admin-v2-svc \
  web-frontend-svc web-backend-svc web-admin-svc \
  final-frontend-svc final-api-svc 2>/dev/null; true
kubectl delete secret myapp-tls final-tls-secret 2>/dev/null; true
echo "Done!"
```{{execute}}
