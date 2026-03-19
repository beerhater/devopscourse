# Step 9: Final task

Create a production-ready Deployment with all three probes and verify behavior.

## 1. Create the app

```bash
cat > final-app.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: final-app-config
data:
  nginx.conf: |
    server {
        listen 80;
        location /healthz { return 200 "OK\n"; add_header Content-Type text/plain; }
        location /ready   { return 200 "OK\n"; add_header Content-Type text/plain; }
        location /        { root /usr/share/nginx/html; index index.html; }
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: final-probes-app
  labels:
    app: final-probes-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: final-probes-app
  template:
    metadata:
      labels:
        app: final-probes-app
    spec:
      volumes:
      - name: config
        configMap:
          name: final-app-config
          items:
          - key: nginx.conf
            path: default.conf
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: config
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
          failureThreshold: 20
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
  name: final-probes-svc
spec:
  selector:
    app: final-probes-app
  ports:
  - port: 80
EOF
kubectl apply -f final-app.yaml
kubectl rollout status deployment/final-probes-app --timeout=60s
```{{execute}}

## 2. Verify all pods are ready and in endpoints

```bash
kubectl get pods -l app=final-probes-app
kubectl get endpoints final-probes-svc
```{{execute}}

## 3. Test probe endpoints

```bash
POD=$(kubectl get pod -l app=final-probes-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD -- wget -qO- http://localhost/healthz
kubectl exec $POD -- wget -qO- http://localhost/ready
```{{execute}}

## 4. Simulate readiness failure on one pod

```bash
POD1=$(kubectl get pod -l app=final-probes-app -o jsonpath='{.items[0].metadata.name}')
POD2=$(kubectl get pod -l app=final-probes-app -o jsonpath='{.items[1].metadata.name}')
echo "Pods: $POD1, $POD2 and more"
echo "Breaking readiness on $POD1..."

# Override the /ready endpoint to return 503
kubectl exec $POD1 -- sh -c "echo 'server { listen 9999; }' > /etc/nginx/conf.d/default.conf && nginx -s reload 2>/dev/null; true"
sleep 15
echo "Endpoints after readiness failure:"
kubectl get endpoints final-probes-svc
kubectl get pods -l app=final-probes-app
```{{execute}}

## 5. Describe pods - see probe config and events

```bash
kubectl describe pod -l app=final-probes-app | grep -A6 'Startup\|Liveness\|Readiness\|Events' | head -40
```{{execute}}

## 6. Cleanup

```bash
kubectl delete deployment readiness-demo both-probes nginx-probes final-probes-app 2>/dev/null; true
kubectl delete service readiness-svc nginx-probes-svc final-probes-svc 2>/dev/null; true
kubectl delete configmap nginx-probe-config final-app-config 2>/dev/null; true
kubectl delete pod liveness-demo liveness-http liveness-http-fixed exec-probe-demo tcp-probe-demo startup-demo 2>/dev/null; true
echo "Cleanup done!"
```{{execute}}
