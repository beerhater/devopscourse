# Step 8: helm repo - install charts from registries

## Add Bitnami repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```{{execute}}

```bash
helm repo list
```{{execute}}

```bash
# Search charts in repo
helm search repo bitnami/nginx
```{{execute}}

```bash
# Show all available versions
helm search repo bitnami/nginx --versions | head -10
```{{execute}}

## Install nginx from Bitnami

```bash
helm install nginx-demo bitnami/nginx \
  --set replicaCount=1 \
  --set service.type=NodePort \
  --set resources.requests.cpu=50m \
  --set resources.requests.memory=64Mi
```{{execute}}

```bash
helm list
kubectl rollout status deployment/nginx-demo -l app.kubernetes.io/name=nginx --timeout=60s 2>/dev/null ||   kubectl rollout status deployment/nginx-demo --timeout=60s
```{{execute}}

```bash
kubectl get pods,svc | grep nginx-demo
```{{execute}}

## Inspect chart before installing

```bash
# Show chart default values
helm show values bitnami/nginx | head -40
```{{execute}}

```bash
# Show chart README
helm show readme bitnami/nginx | head -30
```{{execute}}

## ArtifactHub - discover charts

```bash
cat << 'EOF'
https://artifacthub.io  - public Helm chart registry
  - 10,000+ charts
  - Search by keyword, category, license
  - Verified publishers

helm search hub nginx   - search ArtifactHub from CLI
EOF
```{{execute}}
