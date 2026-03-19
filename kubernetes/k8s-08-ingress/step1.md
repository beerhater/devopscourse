# Shag 1: Problema bez Ingress

## Sozdaem tri servisa

```bash
kubectl create deployment frontend --image=nginx:alpine
kubectl create deployment backend  --image=nginx:alpine
kubectl create deployment api      --image=nginx:alpine
```{{execute}}

```bash
kubectl expose deployment frontend --type=NodePort --port=80 --name=frontend-np
kubectl expose deployment backend  --type=NodePort --port=80 --name=backend-np
kubectl expose deployment api      --type=NodePort --port=80 --name=api-np
```{{execute}}

```bash
kubectl get services | grep -E 'NAME|np'
```{{execute}}

```bash
kubectl get svc frontend-np backend-np api-np \
  -o jsonpath='{range .items[*]}{.metadata.name}: {.spec.ports[0].nodePort}{"\n"}{end}'
echo ""
echo "Problem: different ports, no TLS, no domain routing"
```{{execute}}

```bash
kubectl delete service frontend-np backend-np api-np
kubectl expose deployment frontend --port=80 --name=frontend-svc
kubectl expose deployment backend  --port=80 --name=backend-svc
kubectl expose deployment api      --port=80 --name=api-svc
kubectl get services
```{{execute}}
