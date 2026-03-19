# Step 6: Startup Probe - protecting slow-start containers

Problem: some apps take 60-120s to start (JVM, large databases).
If liveness fires too early it will keep restarting the container.

```
Without Startup Probe:
  initialDelaySeconds=120 -> liveness waits 120s even after fast start

With Startup Probe:
  Startup runs until success -> then Liveness takes over
  failureThreshold * periodSeconds = max startup window
```

## Startup Probe example

```bash
cat > startup-probe.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: startup-demo
spec:
  containers:
  - name: slow-app
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Slow app starting..."
      sleep 10
      echo "Init complete, creating health file"
      touch /tmp/started
      touch /tmp/healthy
      echo "App is ready"
      sleep 3600
    startupProbe:
      exec:
        command: ["test", "-f", "/tmp/started"]
      failureThreshold: 30    # 30 * 2s = 60s max startup window
      periodSeconds: 2        # Check every 2s during startup
    livenessProbe:
      exec:
        command: ["test", "-f", "/tmp/healthy"]
      initialDelaySeconds: 0  # No delay - startup probe handles this
      periodSeconds: 10
      failureThreshold: 3
    readinessProbe:
      exec:
        command: ["test", "-f", "/tmp/healthy"]
      periodSeconds: 5
      failureThreshold: 2
EOF
kubectl apply -f startup-probe.yaml
```{{execute}}

```bash
# Watch startup probe in action
echo "Watching pod during startup..."
for i in $(seq 1 8); do
  STATUS=$(kubectl get pod startup-demo --no-headers 2>/dev/null | awk '{print $2, $3}')
  echo "  $(date +%H:%M:%S) - $STATUS"
  sleep 3
done
```{{execute}}

```bash
# After startup probe passes, liveness takes over
kubectl get pod startup-demo
kubectl describe pod startup-demo | grep -A5 'Startup\|Liveness\|Readiness'
```{{execute}}

## Startup probe vs initialDelaySeconds

```bash
cat << 'EOF'
# Bad pattern - guessing startup time
livenessProbe:
  initialDelaySeconds: 120    # Always waits 120s even if app starts in 5s

# Good pattern - startup probe adapts
startupProbe:
  failureThreshold: 60        # 60 * 2s = 120s max, but checks every 2s
  periodSeconds: 2            # Passes as soon as app is ready
livenessProbe:
  initialDelaySeconds: 0      # Starts immediately after startup probe passes
EOF
```{{execute}}

```bash
kubectl delete pod startup-demo
```{{execute}}
