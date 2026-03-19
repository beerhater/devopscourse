# Shag 3: Pervyj Ingress — bazovyj routing

```bash
cat > basic-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: basic-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-svc
            port:
              number: 80
EOF
kubectl apply -f basic-ingress.yaml
```{{execute}}

```bash
kubectl get ingress basic-ingress
```{{execute}}

```bash
kubectl describe ingress basic-ingress
```{{execute}}

```bash
sleep 5
HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "Request to: http://$NODE_IP:$HTTP_PORT/"
curl -s http://$NODE_IP:$HTTP_PORT/ | grep -o '<title>.*</title>'
```{{execute}}
