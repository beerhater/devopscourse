# Ingress — umnyj HTTP-routing v klastere

Pod bez Ingress kazhdomu servisu nuzhen otdelnyj NodePort ili LoadBalancer.
**Ingress** - edinaya tochka vhoda: odin IP, marshrutizaciya po domenam i putyam.

```
Klient
  |
  v
Ingress Controller (nginx) - odin NodePort/LoadBalancer
  |-- /api/*          -> api-service:8080
  |-- /static/*       -> cdn-service:80
  |-- app.example.com -> app-service:3000
  +-- admin.example.com -> admin-service:4000
```

## Chto izuchim

- Problema bez Ingress
- Ustanovka nginx Ingress Controller
- IngressClass
- Path-based routing
- Host-based routing
- TLS/HTTPS
- Annotations: rate limit, CORS, redirect
- Realnyj primer: frontend + backend + API

> Proveryaem klaster: `kubectl get nodes`{{execute}}
