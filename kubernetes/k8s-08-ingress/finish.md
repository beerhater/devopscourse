# Module complete!

## Chto izuchili

- **Ingress Controller** — nginx pod kotoryj chitaet Ingress-resursy
- **IngressClass** — privyazka Ingress k konkretnomu kontrolleру
- **Path-based routing** — `/api` -> api-svc, `/` -> frontend-svc
- **Host-based routing** — `app.local` -> app-svc, `admin.local` -> admin-svc
- **TLS terminaciya** — HTTPS na kontrolleрe, HTTP vnutri klastera
- **ssl-redirect** — avtomaticheskij HTTP -> HTTPS redirect
- **Annotations** — rate limit, CORS, custom headers, proxy timeouts
- **pathType** — Exact, Prefix, ImplementationSpecific (regex)
- **Cert-Manager** — avtomaticheskie sertifikaty Let's Encrypt

## Shpargalka

```bash
kubectl get ingress
kubectl describe ingress NAME

kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

HTTP_PORT=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

curl -H "Host: myapp.local" http://<node-ip>:$HTTP_PORT/

kubectl create secret tls NAME --cert=tls.crt --key=tls.key
```

## Next module

**StatefulSet** — stateful apps: stable pod names, ordered deploy, individual PVCs.
