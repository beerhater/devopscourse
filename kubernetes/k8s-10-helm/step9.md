# Step 9: helm list, history, get - inspect releases

## helm list variants

```bash
helm list                     # releases in current namespace
```{{execute}}

```bash
helm list --all-namespaces    # all namespaces
```{{execute}}

```bash
helm list -o json | python3 -c "
import json,sys
releases = json.load(sys.stdin)
for r in releases:
    print(f"{r['name']:20} rev:{r['revision']:3} status:{r['status']:10} chart:{r['chart']}")
"
```{{execute}}

## helm history - revision log

```bash
# See all revisions of a release
helm history myapp-release
```{{execute}}

```bash
# Each upgrade creates a new revision
# Failed upgrades are marked as FAILED
helm history nginx-demo
```{{execute}}

## helm get - extract release data

```bash
# What values were set by user
helm get values myapp-release

# All values (user + defaults)
helm get values myapp-release --all | head -20
```{{execute}}

```bash
# Rendered K8s manifests as installed
helm get manifest myapp-release | head -50
```{{execute}}

```bash
# Full release info
helm get all myapp-release | head -30
```{{execute}}

## helm show - inspect chart (not release)

```bash
helm show chart bitnami/nginx          # Chart.yaml
helm show values bitnami/nginx | head -20  # default values.yaml
helm show readme bitnami/nginx | head -10  # README
```{{execute}}

```bash
# Cleanup nginx-demo to free resources
helm uninstall nginx-demo
kubectl get pods | grep nginx-demo || echo "nginx-demo removed"
```{{execute}}
