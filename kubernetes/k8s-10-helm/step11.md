# Step 11: Template functions and pipelines

Helm templates use Go template language + Sprig functions.
Syntax: `{{ functionName arg }}` or `{{ value | function }}`

## Essential functions

```bash
cat > myapp-chart/templates/functions-demo.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-functions
data:
  # quote: wraps string in quotes (required for values that might be numeric)
  app_name: {{ .Values.configData.APP_NAME | quote }}

  # default: fallback value if empty
  log_level: {{ .Values.logLevel | default "info" | quote }}

  # upper / lower
  env_upper: {{ .Values.configData.APP_ENV | default "dev" | upper | quote }}

  # printf: string formatting
  full_image: {{ printf "%s:%s" .Values.image.repository .Values.image.tag | quote }}

  # trimSuffix / trimPrefix
  repo_trimmed: {{ .Values.image.repository | trimPrefix "docker.io/" | quote }}

  # ternary: inline if-else  (condition | ternary trueVal falseVal)
  debug_mode: {{ .Values.ingress.enabled | ternary "ingress-on" "ingress-off" | quote }}

  # int64 / toString conversion
  replicas_str: {{ .Values.replicaCount | int64 | toString | quote }}
EOF
```{{execute}}

```bash
helm template myapp-release myapp-chart | grep -A20 'functions-demo'
```{{execute}}

## toYaml + nindent - embed YAML blocks

```bash
cat > myapp-chart/templates/yaml-block-demo.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-yaml-block
data:
  resources: |
{{ toYaml .Values.resources | indent 4 }}
  extra_env: |
{{ toYaml .Values.extraEnv | indent 4 }}
EOF
```{{execute}}

```bash
helm template myapp-release myapp-chart | grep -A20 'yaml-block-demo'
```{{execute}}

## nindent vs indent

```bash
cat << 'EOF'
{{ toYaml .Values.resources | indent 4 }}   <- adds 4 spaces, no leading newline
{{ toYaml .Values.resources | nindent 4 }}  <- adds newline + 4 spaces (use in most cases)

In deployment.yaml containers section:
  resources:
    {{- toYaml .Values.resources | nindent 4 }}
EOF
```{{execute}}

```bash
# Clean up demo files
rm myapp-chart/templates/functions-demo.yaml myapp-chart/templates/yaml-block-demo.yaml myapp-chart/templates/debug-cm.yaml 2>/dev/null; true
```{{execute}}
