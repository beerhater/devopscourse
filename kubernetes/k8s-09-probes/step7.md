# Step 7: Probe parameters tuning

```bash
cat << 'EOF'
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 10   # Wait before FIRST check (app needs time to start)
  periodSeconds: 10         # How often to check
  timeoutSeconds: 5         # How long to wait for response (default: 1s!)
  failureThreshold: 3       # Consecutive failures before action
  successThreshold: 1       # Consecutive successes to become healthy (liveness: always 1)

readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
  timeoutSeconds: 3
  failureThreshold: 2       # Faster reaction: remove from endpoints after 2 fails
  successThreshold: 2       # Require 2 successes before sending traffic again
EOF
```{{execute}}

## Common mistakes and fixes

```bash
cat > tuning-demo.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-tuning
spec:
  replicas: 2
  selector:
    matchLabels:
      app: probe-tuning
  template:
    metadata:
      labels:
        app: probe-tuning
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
        lifecycle:
          postStart:
            exec:
              command: ["sh", "-c", "echo OK > /usr/share/nginx/html/healthz && echo OK > /usr/share/nginx/html/ready"]
        # Startup probe: give 60s max for container to become live
        startupProbe:
          httpGet:
            path: /healthz
            port: 80
          failureThreshold: 30
          periodSeconds: 2
        # Liveness: restart if stuck for 30s (3 * 10s)
        livenessProbe:
          httpGet:
            path: /healthz
            port: 80
          periodSeconds: 10
          timeoutSeconds: 5         # Not default 1s - gives app time to respond
          failureThreshold: 3
        # Readiness: stop traffic quickly (2 * 5s = 10s reaction time)
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 2
          successThreshold: 2       # Stable before returning to rotation
EOF
kubectl apply -f tuning-demo.yaml
kubectl rollout status deployment/probe-tuning --timeout=60s
```{{execute}}

```bash
kubectl describe pod -l app=probe-tuning | grep -A6 'Startup\|Liveness\|Readiness'
```{{execute}}

## Effect of timeoutSeconds - most overlooked parameter

```bash
cat << 'EOF'
# Default timeoutSeconds: 1  -> app has 1s to respond
# If your app is under load and takes 1.5s -> probe fails -> unnecessary restart!
# Always set timeoutSeconds based on your p99 response time + buffer

Recommended values:
  timeoutSeconds: 3-5   for most web apps
  timeoutSeconds: 10    for database health checks
  timeoutSeconds: 1     only for simple /ping endpoints
EOF
```{{execute}}

```bash
kubectl delete deployment probe-tuning
```{{execute}}
