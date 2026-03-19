# Shag 7: Annotations — tonkaya nastrojka nginx

```bash
cat > rate-limit-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rate-limit-ingress
  annotations:
    nginx.ingress.kubernetes.io/limit-rps: "10"
    nginx.ingress.kubernetes.io/limit-connections: "5"
    nginx.ingress.kubernetes.io/limit-burst-multiplier: "3"
spec:
  ingressClassName: nginx
  rules:
  - host: api.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-v2-svc
            port:
              number: 80
EOF
kubectl apply -f rate-limit-ingress.yaml
```{{execute}}

```bash
cat > cors-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cors-ingress
  annotations:
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "https://frontend.local"
    nginx.ingress.kubernetes.io/cors-allow-methods: "GET, POST, PUT, DELETE, OPTIONS"
    nginx.ingress.kubernetes.io/cors-allow-headers: "Authorization,Content-Type"
    nginx.ingress.kubernetes.io/cors-max-age: "3600"
    nginx.ingress.kubernetes.io/configuration-snippet: |
      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-Content-Type-Options "nosniff";
      add_header X-XSS-Protection "1; mode=block";
spec:
  ingressClassName: nginx
  rules:
  - host: api.local
    http:
      paths:
      - path: /v2
        pathType: Prefix
        backend:
          service:
            name: api-v2-svc
            port:
              number: 80
EOF
kubectl apply -f cors-ingress.yaml
```{{execute}}

```bash
# Proverka zagolovkov CORS
HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
curl -si -H "Host: api.local" -H "Origin: https://frontend.local" \
  http://$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'):$HTTP_PORT/v2 \
  | grep -i 'access-control'
```{{execute}}

```bash
# Spravochnik poleznyh annotations
cat << 'EOF'
nginx.ingress.kubernetes.io/proxy-body-size: "100m"
nginx.ingress.kubernetes.io/proxy-read-timeout: "120"
nginx.ingress.kubernetes.io/proxy-connect-timeout: "10"
nginx.ingress.kubernetes.io/load-balance: "round_robin"
nginx.ingress.kubernetes.io/auth-type: basic
nginx.ingress.kubernetes.io/auth-secret: basic-auth-secret
nginx.ingress.kubernetes.io/whitelist-source-range: "10.0.0.0/8"
nginx.ingress.kubernetes.io/permanent-redirect: "https://new.example.com"
EOF
```{{execute}}

```bash
kubectl get ingress
```{{execute}}
