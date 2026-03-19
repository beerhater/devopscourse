# Shag 2: Ustanovka nginx Ingress Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/baremetal/deploy.yaml
```{{execute}}

```bash
echo "Zhdyom zapuska controller..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s
```{{execute}}

```bash
kubectl get pods -n ingress-nginx
```{{execute}}

```bash
kubectl get svc -n ingress-nginx
```{{execute}}

```bash
HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
HTTPS_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "Node IP:    $NODE_IP"
echo "HTTP port:  $HTTP_PORT"
echo "HTTPS port: $HTTPS_PORT"
```{{execute}}

```bash
kubectl get ingressclass
```{{execute}}
