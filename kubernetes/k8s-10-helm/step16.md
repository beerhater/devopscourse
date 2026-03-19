# Step 16: Install and test devapp chart

## Install devapp

```bash
helm install devapp-release devapp
```{{execute}}

```bash
# NOTES.txt output
helm get notes devapp-release
```{{execute}}

```bash
helm list
kubectl rollout status deployment/devapp-release-devapp --timeout=60s
```{{execute}}

```bash
kubectl get deploy,svc,cm -l "app.kubernetes.io/instance=devapp-release"
```{{execute}}

## Test health endpoints

```bash
POD=$(kubectl get pod -l "app.kubernetes.io/instance=devapp-release" -o jsonpath='{.items[0].metadata.name}')
echo "Testing pod: $POD"
kubectl exec $POD -- wget -qO- http://localhost/healthz
kubectl exec $POD -- wget -qO- http://localhost/ready
```{{execute}}

## Upgrade with new values

```bash
helm upgrade devapp-release devapp \
  --set replicaCount=3 \
  --set config.environment=staging \
  --set config.logLevel=debug \
  --set image.tag=1.25-alpine
```{{execute}}

```bash
kubectl rollout status deployment/devapp-release-devapp --timeout=60s
kubectl get pods -l "app.kubernetes.io/instance=devapp-release"
```{{execute}}

```bash
# Verify config updated
kubectl get cm devapp-release-devapp-config -o jsonpath='{.data.APP_ENV}'
echo ""
kubectl get cm devapp-release-devapp-config -o jsonpath='{.data.LOG_LEVEL}'
echo ""
```{{execute}}

## Enable Ingress via upgrade

```bash
helm upgrade devapp-release devapp \
  --reuse-values \
  --set ingress.enabled=true \
  --set ingress.host=devapp.local
```{{execute}}

```bash
kubectl get ingress 2>/dev/null || echo "No ingress controller - ingress resource created but no routing"
helm get manifest devapp-release | grep -A5 'kind: Ingress' || echo "Ingress not enabled"
```{{execute}}

## --reuse-values flag

```bash
cat << 'EOF'
--reuse-values   <- reuse previous release values + apply new --set flags
                   Good for incremental changes

--reset-values   <- reset to chart defaults + apply new --set flags
                   Good for full reconfigure

Without either:  <- use chart defaults + apply new --set flags (safest)
EOF
```{{execute}}
