# Step 7: --set and --values overrides

Values override priority (highest to lowest):
`--set` > `--values file` > `values.yaml` defaults

## --set flag

```bash
# --set key=value (dot notation for nested)
helm upgrade myapp-release myapp-chart \
  --set replicaCount=3 \
  --set image.tag=1.25-alpine \
  --set service.type=NodePort
```{{execute}}

```bash
helm list
kubectl get deploy myapp-release-myapp-chart -o jsonpath='Replicas: {.spec.replicas}{"
"}'
kubectl get svc | grep myapp
```{{execute}}

## --set for arrays and maps

```bash
# Set array element
helm upgrade myapp-release myapp-chart \
  --set replicaCount=2 \
  --set "extraEnv[0].name=MY_VAR" \
  --set "extraEnv[0].value=hello" \
  --set "configData.CUSTOM_KEY=my-value"
```{{execute}}

## --values flag (override file)

```bash
cat > values-dev.yaml << 'EOF'
replicaCount: 1
image:
  repository: nginx
  tag: alpine
service:
  type: ClusterIP
resources:
  requests:
    cpu: 25m
    memory: 32Mi
  limits:
    cpu: 100m
    memory: 64Mi
configData:
  APP_ENV: development
  DEBUG: "true"
EOF
```{{execute}}

```bash
# Apply dev values
helm upgrade myapp-release myapp-chart --values values-dev.yaml
helm get values myapp-release
```{{execute}}

## Combining --values and --set

```bash
# --set overrides --values (use --set for quick single overrides on top of a file)
helm upgrade myapp-release myapp-chart \
  --values values-dev.yaml \
  --set image.tag=1.25-alpine  # overrides only this one value from file
```{{execute}}

```bash
helm get values myapp-release --all | grep -E 'tag:|replicaCount'
```{{execute}}
