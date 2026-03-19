# Helm: Part 1 + Part 2 -- Charts from zero to production

Helm is the package manager for Kubernetes.
A chart is a bundle of K8s manifests with templating and versioning.

```
Without Helm:  kubectl apply -f deploy.yaml -f svc.yaml -f cm.yaml ...
With Helm:     helm install myapp ./chart --set replicas=3 --set tag=v2
```

## Part 1 -- Helm Fundamentals

- Install Helm 3
- Chart structure: Chart.yaml, values.yaml, templates/
- helm install, list, status, get
- --set and --values overrides
- Install charts from Bitnami repo

## Part 2 -- Writing Your Own Chart

- helm upgrade and rollback
- Template functions: default, quote, toYaml, nindent
- Conditionals if/with and loops range
- _helpers.tpl: named templates
- Build devapp chart: Deployment + Service + ConfigMap + Ingress
- helm lint, template, package
- Multi-environment values: dev / staging / prod

> Check cluster: `kubectl get nodes`{{execute}}
