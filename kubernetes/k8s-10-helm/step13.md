# Step 13: Loops - range over lists and maps

## range over list

```bash
cat > myapp-chart/templates/range-demo.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-range-demo
data:
  # range over list of objects
  env_vars: |
    {{- range .Values.extraEnv }}
    - {{ .name }}={{ .value }}
    {{- end }}

  # range over map keys
  config_keys: |
    {{- range $key, $value := .Values.configData }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
EOF
```{{execute}}

```bash
helm template myapp-release myapp-chart | grep -A20 'range-demo'
```{{execute}}

## range with index

```bash
cat > myapp-chart/templates/range-index.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-range-index
data:
  env_list: |
    {{- range $i, $env := .Values.extraEnv }}
    [{{ $i }}] {{ $env.name }}={{ $env.value }}
    {{- end }}
EOF
```{{execute}}

```bash
helm template myapp-release myapp-chart | grep -A10 'range-index'
```{{execute}}

## Practical use: env vars in Deployment

```bash
cat << 'EOF'
# In deployment.yaml:
env:
  {{- range .Values.extraEnv }}
  - name: {{ .name | quote }}
    value: {{ .value | quote }}
  {{- end }}
  {{- range $key, $val := .Values.configData }}
  - name: {{ $key | quote }}
    value: {{ $val | quote }}
  {{- end }}
EOF
```{{execute}}

```bash
rm myapp-chart/templates/range-demo.yaml myapp-chart/templates/range-index.yaml 2>/dev/null; true
```{{execute}}
