# Step 2: Liveness Probe - httpGet

Liveness probe checks if the container is alive.
On failure: container is restarted (respects restartPolicy).

## httpGet - most common type for web apps

```bash
cat > liveness-http.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: liveness-http
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /healthz          # Health check endpoint
        port: 80
        httpHeaders:
        - name: X-Health-Check
          value: liveness
      initialDelaySeconds: 5    # Wait 5s before first check
      periodSeconds: 10         # Check every 10s
      timeoutSeconds: 3         # Fail if no response in 3s
      failureThreshold: 3       # Restart after 3 consecutive failures
      successThreshold: 1       # 1 success = healthy again
EOF
kubectl apply -f liveness-http.yaml
kubectl wait --for=condition=Ready pod/liveness-http --timeout=30s
```{{execute}}

```bash
# Probe is hitting / because /healthz does not exist -> nginx returns 404
# 404 is NOT a success for liveness probe (needs 200-399)
kubectl describe pod liveness-http | grep -A8 'Liveness:'
```{{execute}}

```bash
# Fix: create a proper /healthz endpoint
kubectl delete pod liveness-http

cat > liveness-http-fixed.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: liveness-http-fixed
  labels:
    app: liveness-demo
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
    # Create healthz endpoint via nginx config
    lifecycle:
      postStart:
        exec:
          command:
          - sh
          - -c
          - |
            mkdir -p /usr/share/nginx/html
            echo "OK" > /usr/share/nginx/html/healthz
    livenessProbe:
      httpGet:
        path: /healthz
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 10
      timeoutSeconds: 3
      failureThreshold: 3
      successThreshold: 1
EOF
kubectl apply -f liveness-http-fixed.yaml
kubectl wait --for=condition=Ready pod/liveness-http-fixed --timeout=30s
```{{execute}}

```bash
kubectl describe pod liveness-http-fixed | grep -A8 'Liveness:'
```{{execute}}

## Simulate failure: remove health file

```bash
kubectl exec liveness-http-fixed -- rm /usr/share/nginx/html/healthz
echo "Health file removed - probe will return 404 soon"
sleep 35
kubectl get pod liveness-http-fixed
echo "Restarts show liveness probe triggered a restart"
```{{execute}}

```bash
kubectl delete pod liveness-http-fixed liveness-http 2>/dev/null; true
```{{execute}}
