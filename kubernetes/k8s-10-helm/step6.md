# Step 6: Template syntax - .Values .Release .Chart

## Built-in objects

```bash
cat << 'EOF'
.Values.xxx          <- from values.yaml + overrides
.Release.Name        <- release name (helm install NAME ...)
.Release.Namespace   <- namespace of the release
.Release.IsInstall   <- true during first install
.Release.IsUpgrade   <- true during upgrade
.Chart.Name          <- from Chart.yaml .name
.Chart.Version       <- from Chart.yaml .version
.Chart.AppVersion    <- from Chart.yaml .appVersion
.Files.Get "file"    <- read file from chart directory
.Capabilities.KubeVersion.Minor  <- K8s server version
EOF
```{{execute}}

## Look at deployment template in detail

```bash
cat myapp-chart/templates/deployment.yaml
```{{execute}}

## Create a custom template to see all objects live

```bash
cat > myapp-chart/templates/debug-cm.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-debug
  namespace: {{ .Release.Namespace }}
  labels:
    chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    app-version: {{ .Chart.AppVersion }}
    release: {{ .Release.Name }}
data:
  release_name: {{ .Release.Name | quote }}
  chart_name: {{ .Chart.Name | quote }}
  chart_version: {{ .Chart.Version | quote }}
  app_version: {{ .Chart.AppVersion | quote }}
  namespace: {{ .Release.Namespace | quote }}
  replicas: {{ .Values.replicaCount | quote }}
  image: {{ printf "%s:%s" .Values.image.repository .Values.image.tag | quote }}
EOF
```{{execute}}

```bash
# Render to see output
helm template myapp-release myapp-chart | grep -A20 'debug-cm'
```{{execute}}

```bash
# Upgrade to apply the new template
helm upgrade myapp-release myapp-chart
kubectl get configmap myapp-release-debug -o yaml
```{{execute}}
