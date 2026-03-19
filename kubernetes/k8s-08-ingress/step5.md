# Shag 5: Host-based routing

```bash
cat > host-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: host-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: frontend.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-v2-svc
            port:
              number: 80
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
  - host: admin.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: admin-v2-svc
            port:
              number: 80
EOF
kubectl apply -f host-ingress.yaml
kubectl get ingress host-ingress
```{{execute}}

```bash
HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "=== frontend.local ==="
curl -s -H "Host: frontend.local" http://$NODE_IP:$HTTP_PORT/ | grep -o '<title>.*</title>'
echo "=== api.local ==="
curl -s -H "Host: api.local" http://$NODE_IP:$HTTP_PORT/ | grep -o '<title>.*</title>'
echo "=== admin.local ==="
curl -s -H "Host: admin.local" http://$NODE_IP:$HTTP_PORT/ | grep -o '<title>.*</title>'
echo "=== unknown host ==="
curl -s -H "Host: unknown.local" http://$NODE_IP:$HTTP_PORT/ | head -2
```{{execute}}

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
grep -q 'frontend.local' /etc/hosts || cat >> /etc/hosts << HOSTS
$NODE_IP frontend.local
$NODE_IP api.local
$NODE_IP admin.local
HOSTS
echo "Added to /etc/hosts:"
grep '\.local' /etc/hosts
```{{execute}}

```bash
HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
curl -s http://frontend.local:$HTTP_PORT/ | grep -o '<title>.*</title>'
curl -s http://api.local:$HTTP_PORT/      | grep -o '<title>.*</title>'
```{{execute}}
