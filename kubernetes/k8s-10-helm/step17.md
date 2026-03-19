# Step 17: helm lint, template, package

## helm lint - validate chart

```bash
helm lint devapp
```{{execute}}

```bash
# Lint with custom values
helm lint devapp --set ingress.enabled=true --set ingress.host=devapp.local
```{{execute}}

```bash
# Introduce an error and see lint output
echo "  bad: {{  .Values.missing.key  }" >> devapp/templates/configmap.yaml
helm lint devapp 2>&1 || true
# Fix the error
head -n -1 devapp/templates/configmap.yaml > /tmp/cm_fixed.yaml
mv /tmp/cm_fixed.yaml devapp/templates/configmap.yaml
```{{execute}}

## helm template - render without installing

```bash
# Full render
helm template devapp-release devapp | grep '^kind:' | sort | uniq -c
```{{execute}}

```bash
# Render with values
helm template devapp-release devapp \
  --set replicaCount=5 \
  --set ingress.enabled=true \
  --set config.environment=production | grep -E 'replicas:|APP_ENV'
```{{execute}}

```bash
# Render single template file
helm template devapp-release devapp -s templates/configmap.yaml
```{{execute}}

## helm package - create .tgz archive

```bash
helm package devapp
ls -lh devapp-*.tgz
```{{execute}}

```bash
# Package with bumped version
helm package devapp --version 1.1.0 --app-version 2.0.0
ls -lh devapp-*.tgz
```{{execute}}

```bash
# Inspect the package
tar -tzf devapp-1.0.0.tgz | head -20
```{{execute}}

## Create a local chart repository

```bash
mkdir -p local-repo
mv devapp-*.tgz local-repo/
helm repo index local-repo/ --url file://$(pwd)/local-repo
cat local-repo/index.yaml
```{{execute}}

```bash
# Add local repo
helm repo add local-devapp file://$(pwd)/local-repo
helm repo update
helm search repo local-devapp
```{{execute}}
