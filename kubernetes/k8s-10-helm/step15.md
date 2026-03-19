# Step 15: Build devapp chart - Deployment + Service + ConfigMap

Now we build a complete chart from scratch for the app from our Docker module.
This is a production-style web application chart.

## Create chart directory

```bash
mkdir -p devapp/{templates,charts}
```{{execute}}

## Chart.yaml

```bash
cat > devapp/Chart.yaml << 'EOF'
apiVersion: v2
name: devapp
description: DevOps course web application - built from Docker module
type: application
version: 1.0.0
appVersion: "1.0.0"
keywords:
- nginx
- web
- devops
maintainers:
- name: DevOps Engineer
EOF
```{{execute}}

## values.yaml

```bash
cat > devapp/values.yaml << 'EOF'
replicaCount: 2

image:
  repository: nginx
  tag: "alpine"
  pullPolicy: IfNotPresent

nameOverride: ""
fullnameOverride: ""

service:
  type: ClusterIP
  port: 80
  targetPort: 80

ingress:
  enabled: false
  className: "nginx"
  host: "devapp.local"
  annotations: {}

resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 200m
    memory: 128Mi

config:
  appName: "DevApp"
  appVersion: "1.0.0"
  environment: "production"
  logLevel: "info"

nginx:
  port: 80
  workerProcesses: "auto"

extraEnv: []

podAnnotations: {}

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
EOF
```{{execute}}

## _helpers.tpl

```bash
cat > devapp/templates/_helpers.tpl << 'EOF'
{{/*
Expand the name of the chart.
*/}}
{{- define "devapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "devapp.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "devapp.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "devapp.labels" -}}
helm.sh/chart: {{ include "devapp.name" . }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "devapp.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "devapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Image string
*/}}
{{- define "devapp.image" -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- end }}
EOF
```{{execute}}

## ConfigMap template

```bash
cat > devapp/templates/configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "devapp.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "devapp.labels" . | nindent 4 }}
data:
  APP_NAME: {{ .Values.config.appName | quote }}
  APP_VERSION: {{ .Values.config.appVersion | quote }}
  APP_ENV: {{ .Values.config.environment | quote }}
  LOG_LEVEL: {{ .Values.config.logLevel | quote }}
  nginx.conf: |
    worker_processes {{ .Values.nginx.workerProcesses }};
    events { worker_connections 1024; }
    http {
      server {
        listen {{ .Values.nginx.port }};
        location /healthz { return 200 "OK
"; add_header Content-Type text/plain; }
        location /ready   { return 200 "OK
"; add_header Content-Type text/plain; }
        location / { root /usr/share/nginx/html; index index.html; }
      }
    }
EOF
```{{execute}}

## Deployment template

```bash
cat > devapp/templates/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "devapp.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "devapp.labels" . | nindent 4 }}
  {{- with .Values.podAnnotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "devapp.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "devapp.selectorLabels" . | nindent 8 }}
    spec:
      volumes:
      - name: nginx-conf
        configMap:
          name: {{ include "devapp.fullname" . }}-config
          items:
          - key: nginx.conf
            path: nginx.conf
      containers:
      - name: {{ .Chart.Name }}
        image: {{ include "devapp.image" . }}
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: http
          containerPort: {{ .Values.nginx.port }}
          protocol: TCP
        volumeMounts:
        - name: nginx-conf
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        envFrom:
        - configMapRef:
            name: {{ include "devapp.fullname" . }}-config
        {{- if .Values.extraEnv }}
        env:
          {{- toYaml .Values.extraEnv | nindent 8 }}
        {{- end }}
        livenessProbe:
          httpGet:
            path: /healthz
            port: http
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /ready
            port: http
          initialDelaySeconds: 3
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 2
        resources:
          {{- toYaml .Values.resources | nindent 10 }}
EOF
```{{execute}}

## Service template

```bash
cat > devapp/templates/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: {{ include "devapp.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "devapp.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
  - port: {{ .Values.service.port }}
    targetPort: http
    protocol: TCP
    name: http
  selector:
    {{- include "devapp.selectorLabels" . | nindent 4 }}
EOF
```{{execute}}

## Ingress template (conditional)

```bash
cat > devapp/templates/ingress.yaml << 'EOF'
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "devapp.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "devapp.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{ .Values.ingress.className }}
  {{- end }}
  rules:
  - host: {{ .Values.ingress.host | quote }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ include "devapp.fullname" . }}
            port:
              number: {{ .Values.service.port }}
{{- end }}
EOF
```{{execute}}

## NOTES.txt

```bash
cat > devapp/templates/NOTES.txt << 'EOF'
DevApp {{ .Chart.AppVersion }} deployed as release {{ .Release.Name }}!

Get the application URL:
{{- if .Values.ingress.enabled }}
  http://{{ .Values.ingress.host }}
{{- else if eq .Values.service.type "NodePort" }}
  export NODE_PORT=$(kubectl get svc {{ include "devapp.fullname" . }} -o jsonpath='{.spec.ports[0].nodePort}')
  export NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')
  echo "http://$NODE_IP:$NODE_PORT"
{{- else }}
  kubectl port-forward svc/{{ include "devapp.fullname" . }} 8080:80
  echo "http://localhost:8080"
{{- end }}
EOF
```{{execute}}

```bash
# Lint before install
helm lint devapp
```{{execute}}

```bash
# Preview rendered manifests
helm template devapp-release devapp | head -60
```{{execute}}
