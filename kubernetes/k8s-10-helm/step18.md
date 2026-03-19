# Step 18: Multi-environment values and final deployment

## Environment-specific values files

```bash
cat > values-dev.yaml << 'EOF'
replicaCount: 1
image:
  repository: nginx
  tag: alpine
config:
  appName: "DevApp"
  environment: development
  logLevel: debug
resources:
  requests:
    cpu: 25m
    memory: 32Mi
  limits:
    cpu: 100m
    memory: 64Mi
autoscaling:
  enabled: false
extraEnv:
- name: DEBUG
  value: "true"
EOF
```{{execute}}

```bash
cat > values-staging.yaml << 'EOF'
replicaCount: 2
image:
  repository: nginx
  tag: "1.25-alpine"
config:
  appName: "DevApp"
  environment: staging
  logLevel: info
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 200m
    memory: 128Mi
autoscaling:
  enabled: false
EOF
```{{execute}}

```bash
cat > values-prod.yaml << 'EOF'
replicaCount: 3
image:
  repository: nginx
  tag: "1.25-alpine"
config:
  appName: "DevApp"
  environment: production
  logLevel: warning
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
EOF
```{{execute}}

## Deploy to dev and staging namespaces

```bash
kubectl create namespace dev 2>/dev/null; true
kubectl create namespace staging 2>/dev/null; true
```{{execute}}

```bash
# Deploy to dev
helm install devapp-dev devapp \
  --namespace dev \
  --values values-dev.yaml
kubectl rollout status deployment -n dev --timeout=60s
```{{execute}}

```bash
# Deploy to staging
helm install devapp-staging devapp \
  --namespace staging \
  --values values-staging.yaml
kubectl rollout status deployment -n staging --timeout=60s
```{{execute}}

```bash
# See all releases across namespaces
helm list --all-namespaces
```{{execute}}

```bash
# Compare environments
echo "=== DEV replicas ===" && kubectl get deploy -n dev -o jsonpath='{.items[0].spec.replicas}'
echo ""
echo "=== STAGING replicas ===" && kubectl get deploy -n staging -o jsonpath='{.items[0].spec.replicas}'
echo ""
echo "=== DEV config ===" && kubectl get cm -n dev -o jsonpath='{.items[0].data.APP_ENV}'
echo ""
echo "=== STAGING config ===" && kubectl get cm -n staging -o jsonpath='{.items[0].data.APP_ENV}'
echo ""
```{{execute}}

## Final: promote staging to prod

```bash
helm install devapp-prod devapp \
  --namespace default \
  --values values-prod.yaml \
  --set image.tag=1.25-alpine
kubectl rollout status deployment/devapp-prod-devapp --timeout=60s
```{{execute}}

```bash
# Final state
helm list --all-namespaces
echo ""
kubectl get deploy devapp-prod-devapp \
  -o jsonpath='Image: {.spec.template.spec.containers[0].image}{"
"}Replicas: {.spec.replicas}{"
"}'
```{{execute}}

## Cleanup

```bash
helm uninstall devapp-release devapp-prod myapp-release 2>/dev/null; true
helm uninstall devapp-dev --namespace dev 2>/dev/null; true
helm uninstall devapp-staging --namespace staging 2>/dev/null; true
helm repo remove local-devapp 2>/dev/null; true
kubectl delete namespace dev staging 2>/dev/null; true
echo "Cleanup done!"
```{{execute}}
