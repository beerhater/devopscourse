# Step 14: _helpers.tpl - named templates

`_helpers.tpl` defines reusable template snippets via `define`.
Files starting with `_` are NOT rendered as K8s resources.

## Inspect generated _helpers.tpl

```bash
cat myapp-chart/templates/_helpers.tpl
```{{execute}}

## Add custom helpers

```bash
cat >> myapp-chart/templates/_helpers.tpl << 'EOF'

{{/*
Standard labels added to every resource
*/}}
{{- define "myapp-chart.labels.standard" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Image string: repository:tag
*/}}
{{- define "myapp-chart.image" -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- end }}

{{/*
Resource name with release prefix
*/}}
{{- define "myapp-chart.resourceName" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}
EOF
```{{execute}}

## Use named templates with include

```bash
cat > myapp-chart/templates/helpers-demo.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "myapp-chart.resourceName" . }}-helpers-demo
  labels:
    {{- include "myapp-chart.labels.standard" . | nindent 4 }}
data:
  image: {{ include "myapp-chart.image" . | quote }}
  resource_name: {{ include "myapp-chart.resourceName" . | quote }}
EOF
```{{execute}}

```bash
helm template myapp-release myapp-chart | grep -A20 'helpers-demo'
```{{execute}}

## include vs template

```bash
cat << 'EOF'
{{ template "name" . }}   <- old syntax, cannot be piped
{{ include "name" . }}    <- new syntax, can be piped to nindent/indent

Always use include:
  labels:
    {{- include "myapp-chart.labels" . | nindent 4 }}
EOF
```{{execute}}

```bash
rm myapp-chart/templates/helpers-demo.yaml 2>/dev/null; true
```{{execute}}
