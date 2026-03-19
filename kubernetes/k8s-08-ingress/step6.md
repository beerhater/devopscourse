# Shag 6: TLS/HTTPS

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=myapp.local/O=DevOps" \
  -addext "subjectAltName=DNS:myapp.local" 2>/dev/null
echo "Certificate created:"
openssl x509 -in tls.crt -noout -subject -dates
```{{execute}}

```bash
kubectl create secret tls myapp-tls --cert=tls.crt --key=tls.key
kubectl describe secret myapp-tls
```{{execute}}

```bash
cat > tls-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - myapp.local
    secretName: myapp-tls
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-v2-svc
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-v2-svc
            port:
              number: 80
EOF
kubectl apply -f tls-ingress.yaml
kubectl get ingress tls-ingress
```{{execute}}

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
grep -q 'myapp.local' /etc/hosts || echo "$NODE_IP myapp.local" >> /etc/hosts

HTTPS_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

echo "=== HTTPS request ==="
curl -sk https://myapp.local:$HTTPS_PORT/ | grep -o '<title>.*</title>'

echo "=== HTTP -> HTTPS redirect ==="
curl -si http://myapp.local:$HTTP_PORT/ | grep -E 'HTTP/|Location:'
```{{execute}}

## Cert-Manager (production)

```bash
cat << 'EOF'
# Avtomat. sertifikat Let's Encrypt cherez cert-manager
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts: ["myapp.example.com"]
    secretName: myapp-tls-auto   # cert-manager sozdast Secret sam
EOF
```{{execute}}
