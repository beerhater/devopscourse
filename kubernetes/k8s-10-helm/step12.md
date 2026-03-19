# Step 12: Conditionals - if, with, else

## {{- if }} block

```bash
cat > myapp-chart/templates/conditional-demo.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-conditional
data:
  mode: "base"
  {{- if .Values.ingress.enabled }}
  ingress_host: {{ .Values.ingress.host | quote }}
  ingress_path: {{ .Values.ingress.path | quote }}
  {{- end }}

  {{- if eq .Values.service.type "NodePort" }}
  access: "external-nodeport"
  {{- else if eq .Values.service.type "LoadBalancer" }}
  access: "external-lb"
  {{- else }}
  access: "internal-only"
  {{- end }}

  {{- if and .Values.autoscaling.enabled (gt .Values.autoscaling.maxReplicas 3) }}
  hpa: "large-scale"
  {{- end }}
EOF
```{{execute}}

```bash
# With ingress disabled (default)
helm template myapp-release myapp-chart \
  --set ingress.enabled=false \
  --set service.type=ClusterIP | grep -A15 'conditional'
```{{execute}}

```bash
# With ingress enabled
helm template myapp-release myapp-chart \
  --set ingress.enabled=true \
  --set service.type=NodePort | grep -A15 'conditional'
```{{execute}}

## {{- with }} block - scope change

```bash
cat > myapp-chart/templates/with-demo.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-with-demo
data:
  {{- with .Values.image }}
  repository: {{ .repository | quote }}
  tag: {{ .tag | quote }}
  full: {{ printf "%s:%s" .repository .tag | quote }}
  {{- end }}

  {{- with .Values.configData }}
  app_name: {{ .APP_NAME | quote }}
  app_version: {{ .APP_VERSION | quote }}
  {{- end }}
EOF
```{{execute}}

```bash
helm template myapp-release myapp-chart | grep -A10 'with-demo'
```{{execute}}

```bash
# Note: {{- (dash) trims whitespace/newlines before the tag
# Without dash: blank lines appear in output
# With dash:    clean output
rm myapp-chart/templates/conditional-demo.yaml myapp-chart/templates/with-demo.yaml 2>/dev/null; true
```{{execute}}
