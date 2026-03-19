# Step 10: helm upgrade and rollback

## helm upgrade

```bash
# Check current revision
helm list
helm history myapp-release
```{{execute}}

```bash
# Upgrade with new values
helm upgrade myapp-release myapp-chart \
  --set replicaCount=3 \
  --set image.tag=1.25-alpine
```{{execute}}

```bash
# Revision increased
helm list
helm history myapp-release
```{{execute}}

```bash
kubectl get deploy myapp-release-myapp-chart \
  -o jsonpath='Image: {.spec.template.spec.containers[0].image}{"
"}Replicas: {.spec.replicas}{"
"}'
```{{execute}}

## --install flag: upgrade or install in one command

```bash
# Idempotent: installs if not exists, upgrades if exists
helm upgrade --install myapp-release myapp-chart \
  --set replicaCount=2 \
  --set image.tag=alpine
```{{execute}}

## --atomic flag: rollback automatically on failure

```bash
cat << 'EOF'
helm upgrade myapp-release myapp-chart --atomic --timeout 120s
  --atomic: if upgrade fails within timeout -> auto rollback to last good revision
  Great for CI/CD pipelines
EOF
```{{execute}}

## helm rollback

```bash
helm history myapp-release
```{{execute}}

```bash
# Rollback to specific revision
helm rollback myapp-release 1
```{{execute}}

```bash
# Revision AFTER rollback is a NEW revision (not going back)
helm history myapp-release
```{{execute}}

```bash
kubectl get deploy myapp-release-myapp-chart \
  -o jsonpath='Image: {.spec.template.spec.containers[0].image}{"
"}Replicas: {.spec.replicas}{"
"}'
```{{execute}}

## helm uninstall

```bash
# Uninstall removes ALL K8s resources created by the release
helm uninstall myapp-release --dry-run
```{{execute}}
