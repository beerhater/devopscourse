# Step 4: values.yaml - defaults and data types

`values.yaml` is the single source of configuration truth.
Templates reference values via `{{ .Values.key }}`.

## Rewrite values.yaml with all data types

```bash
cat > myapp-chart/values.yaml << 'EOF'
# Scalar values
replicaCount: 2
nameOverride: ""
fullnameOverride: ""

# Nested object
image:
  repository: nginx
  tag: "alpine"
  pullPolicy: IfNotPresent

# Service object
service:
  type: ClusterIP
  port: 80

# Ingress object with nested map
ingress:
  enabled: false
  className: "nginx"
  host: "myapp.local"
  path: /

# Resource limits object
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 200m
    memory: 128Mi

# Boolean flag
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 5

# List (array)
extraEnv:
- name: APP_ENV
  value: production
- name: LOG_LEVEL
  value: info

# Map / dict
configData:
  APP_NAME: "MyApp"
  APP_VERSION: "1.0.0"

# Multiline string
nginxConfig: |
  server {
    listen 80;
    location /healthz { return 200 "OK"; }
  }
EOF
```{{execute}}

```bash
cat myapp-chart/values.yaml
```{{execute}}

## Value types in templates

```bash
cat << 'EOF'
{{ .Values.replicaCount }}          -> 2
{{ .Values.image.repository }}      -> nginx
{{ .Values.image.tag }}             -> alpine
{{ .Values.ingress.enabled }}       -> false
{{ .Values.extraEnv }}              -> list of maps
{{ toYaml .Values.resources }}      -> YAML block
EOF
```{{execute}}
