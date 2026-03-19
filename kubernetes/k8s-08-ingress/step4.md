# Shag 4: Path-based routing

```bash
kubectl create deployment frontend-v2 --image=nginx:alpine
kubectl create deployment api-v2      --image=nginx:alpine
kubectl create deployment admin-v2    --image=nginx:alpine
kubectl wait --for=condition=available deployment/frontend-v2 deployment/api-v2 deployment/admin-v2 --timeout=60s
kubectl expose deployment frontend-v2 --port=80 --name=frontend-v2-svc
kubectl expose deployment api-v2      --port=80 --name=api-v2-svc
kubectl expose deployment admin-v2    --port=80 --name=admin-v2-svc
```{{execute}}

```bash
cat > path-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: path-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /api(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: api-v2-svc
            port:
              number: 80
      - path: /admin(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: admin-v2-svc
            port:
              number: 80
      - path: /()(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: frontend-v2-svc
            port:
              number: 80
EOF
kubectl apply -f path-ingress.yaml
kubectl get ingress path-ingress
```{{execute}}

```bash
HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "=== / ==="
curl -s http://$NODE_IP:$HTTP_PORT/ | grep -o '<title>.*</title>'
echo "=== /api ==="
curl -s http://$NODE_IP:$HTTP_PORT/api | grep -o '<title>.*</title>'
echo "=== /admin ==="
curl -s http://$NODE_IP:$HTTP_PORT/admin | grep -o '<title>.*</title>'
```{{execute}}

## pathType - tri varianta

| pathType | Opisanie | Primer |
|----------|----------|--------|
| `Exact` | Tochnoe sovpadenie | `/api` ne = `/api/` |
| `Prefix` | Sovpadenie po prefiksu | `/api` = `/api`, `/api/users` |
| `ImplementationSpecific` | Pravila kontrollera (regex) | `/api(/\|$)(.*)` |
