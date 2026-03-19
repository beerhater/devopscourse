# Step 5: First helm install - local chart

## Render templates before installing (dry-run)

```bash
helm template myapp-release myapp-chart
```{{execute}}

```bash
# Dry-run: show what would be sent to K8s
helm install myapp-release myapp-chart --dry-run --debug 2>&1 | head -40
```{{execute}}

## Install the chart

```bash
helm install myapp-release myapp-chart
```{{execute}}

```bash
# List all releases
helm list
```{{execute}}

```bash
# Check what K8s resources were created
kubectl get deploy,svc,sa -l "app.kubernetes.io/instance=myapp-release"
```{{execute}}

## helm status - release details

```bash
helm status myapp-release
```{{execute}}

```bash
# NOTES.txt content shown after install
helm get notes myapp-release
```{{execute}}

## Release stored as K8s Secret

```bash
kubectl get secrets | grep helm
kubectl get secret sh.helm.release.v1.myapp-release.v1 -o jsonpath='{.type}'
echo ""
```{{execute}}

## helm get - inspect installed release

```bash
helm get values myapp-release        # User-supplied values (empty = used defaults)
helm get values myapp-release --all  # All values including defaults
```{{execute}}

```bash
helm get manifest myapp-release | head -30   # Rendered K8s manifests
```{{execute}}
