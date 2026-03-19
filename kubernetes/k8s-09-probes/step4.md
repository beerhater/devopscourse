# Step 4: Liveness vs Readiness - key differences

```bash
cat > both-probes.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: both-probes
spec:
  replicas: 2
  selector:
    matchLabels:
      app: both-probes
  template:
    metadata:
      labels:
        app: both-probes
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
        lifecycle:
          postStart:
            exec:
              command:
              - sh
              - -c
              - |
                echo "OK" > /usr/share/nginx/html/healthz
                echo "OK" > /usr/share/nginx/html/ready
        livenessProbe:
          httpGet:
            path: /healthz        # Is the process alive?
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
          failureThreshold: 3     # 3 fails -> restart (30s window)
        readinessProbe:
          httpGet:
            path: /ready          # Is the app ready for traffic?
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 5
          failureThreshold: 2     # 2 fails -> remove from endpoints (10s window)
          successThreshold: 2     # 2 successes -> add back to endpoints
EOF
kubectl apply -f both-probes.yaml
kubectl rollout status deployment/both-probes --timeout=60s
```{{execute}}

```bash
kubectl describe pod -l app=both-probes | grep -A6 'Liveness:\|Readiness:'
```{{execute}}

## Comparison table

| | Liveness | Readiness |
|--|----------|-----------|
| Fail action | Restart container | Remove from endpoints |
| Pod status | Restarts (CrashLoopBackOff) | Running but 0/1 Ready |
| Traffic | Stops during restart | Stops immediately on fail |
| Use case | Deadlock, stuck process | Slow init, dependency down |
| Restart count | Increases | Does NOT increase |

## Scenario: Only readiness fails (dependency down)

```bash
POD=$(kubectl get pod -l app=both-probes -o jsonpath='{.items[0].metadata.name}')
echo "Breaking ONLY readiness (dependency simulation)..."
kubectl exec $POD -- rm /usr/share/nginx/html/ready
sleep 12
echo ""
kubectl get pod -l app=both-probes
echo ""
echo "Pod READY 0/1 but restart count stays 0 - no restart happened"
kubectl get pod $POD -o jsonpath='Restarts: {.status.containerStatuses[0].restartCount}{"
"}'
```{{execute}}

```bash
# Restore readiness
kubectl exec $POD -- sh -c "echo OK > /usr/share/nginx/html/ready"
sleep 15
kubectl get pod -l app=both-probes
```{{execute}}

## Scenario: Only liveness fails (deadlock)

```bash
POD=$(kubectl get pod -l app=both-probes -o jsonpath='{.items[0].metadata.name}')
RESTARTS_BEFORE=$(kubectl get pod $POD -o jsonpath='{.status.containerStatuses[0].restartCount}')
echo "Restarts before: $RESTARTS_BEFORE"
echo "Breaking ONLY liveness (deadlock simulation)..."
kubectl exec $POD -- rm /usr/share/nginx/html/healthz
sleep 40
NEW_POD=$(kubectl get pod -l app=both-probes -o jsonpath='{.items[0].metadata.name}')
kubectl get pod $NEW_POD
kubectl get pod $NEW_POD -o jsonpath='Restarts: {.status.containerStatuses[0].restartCount}{"
"}'
echo "Restart count increased - liveness triggered restart"
```{{execute}}
