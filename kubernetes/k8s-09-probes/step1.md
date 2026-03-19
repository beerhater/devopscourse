# Step 1: Problem - K8s does not know app health without probes

## Container running but app is broken

```bash
# App that starts, then breaks after 15 seconds
cat > broken-app.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: broken-pod
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "App starting..."
      sleep 15
      echo "App is now BROKEN - simulating crash"
      # File is gone - app returns errors but process stays alive
      while true; do
        echo "ERROR: app broken but process alive" >&2
        sleep 5
      done
EOF
kubectl apply -f broken-app.yaml
kubectl wait --for=condition=Ready pod/broken-pod --timeout=30s
```{{execute}}

```bash
# Pod shows Running - but app is broken
sleep 16
kubectl get pod broken-pod
echo ""
echo "Pod status: Running - but app is returning errors!"
echo "Without probes K8s has no idea the app is broken."
```{{execute}}

```bash
# K8s only restarts if the process EXITS
# A stuck or erroring process that stays alive = K8s does nothing
kubectl describe pod broken-pod | grep -E 'State:|Restart'
kubectl delete pod broken-pod
```{{execute}}

## The fix: Liveness Probe

```bash
cat > liveness-demo.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: liveness-demo
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      # Create health file on start
      touch /tmp/healthy
      echo "App started, healthy file created"
      # After 20s - remove health file to simulate failure
      sleep 20
      rm /tmp/healthy
      echo "Health file removed - liveness probe will fail now"
      sleep 3600
    livenessProbe:
      exec:
        command: ["cat", "/tmp/healthy"]
      initialDelaySeconds: 5
      periodSeconds: 5
      failureThreshold: 3
EOF
kubectl apply -f liveness-demo.yaml
kubectl wait --for=condition=Ready pod/liveness-demo --timeout=30s
echo "Pod started - watching..."
```{{execute}}

```bash
# Watch restarts happen
sleep 35
kubectl get pod liveness-demo
echo ""
echo "RESTARTS > 0 means liveness probe worked!"
kubectl describe pod liveness-demo | grep -E 'Restart|Liveness|Unhealthy' | head -10
```{{execute}}

```bash
kubectl delete pod liveness-demo
```{{execute}}
