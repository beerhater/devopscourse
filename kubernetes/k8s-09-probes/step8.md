# Step 8: Real example - nginx + backend with all probes

```bash
cat > real-app.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-probe-config
data:
  default.conf: |
    server {
        listen 80;

        location /healthz {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }

        location /ready {
            access_log off;
            return 200 "ready\n";
            add_header Content-Type text/plain;
        }

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-probes
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-probes
  template:
    metadata:
      labels:
        app: nginx-probes
    spec:
      volumes:
      - name: nginx-config
        configMap:
          name: nginx-probe-config
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/conf.d
        resources:
          requests:
            cpu: 50m
            memory: 32Mi
          limits:
            cpu: 200m
            memory: 64Mi
        startupProbe:
          httpGet:
            path: /healthz
            port: 80
          failureThreshold: 15
          periodSeconds: 2
        livenessProbe:
          httpGet:
            path: /healthz
            port: 80
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 2
          successThreshold: 1
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-probes-svc
spec:
  selector:
    app: nginx-probes
  ports:
  - port: 80
EOF
kubectl apply -f real-app.yaml
kubectl rollout status deployment/nginx-probes --timeout=60s
```{{execute}}

```bash
# All pods healthy and in endpoints
kubectl get pods -l app=nginx-probes
kubectl get endpoints nginx-probes-svc
```{{execute}}

```bash
# Test health endpoints directly
POD=$(kubectl get pod -l app=nginx-probes -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD -- wget -qO- http://localhost/healthz
kubectl exec $POD -- wget -qO- http://localhost/ready
```{{execute}}

```bash
# Simulate rolling update - readiness prevents bad pods from getting traffic
kubectl set image deployment/nginx-probes nginx=nginx:1.25-alpine 2>/dev/null ||   kubectl set image deployment/nginx-probes nginx=nginx:alpine
kubectl rollout status deployment/nginx-probes --timeout=60s
echo "Rolling update complete - readiness probe ensured zero downtime"
```{{execute}}

```bash
# Events show probe history
kubectl describe deployment nginx-probes | grep -A5 'RollingUpdate\|Events'
kubectl get pods -l app=nginx-probes
```{{execute}}
