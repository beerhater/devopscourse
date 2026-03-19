# Step 3: Readiness Probe - traffic control

Readiness probe does NOT restart the container.
On failure: pod is removed from Service endpoints (no traffic sent to it).
On success: pod is added back to Service endpoints.

```
Liveness fail  -> restart container
Readiness fail -> stop sending traffic (pod stays Running)
```

## Demo: Readiness controls Service endpoints

```bash
cat > readiness-demo.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: readiness-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: readiness-demo
  template:
    metadata:
      labels:
        app: readiness-demo
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        lifecycle:
          postStart:
            exec:
              command: ["sh", "-c", "echo OK > /usr/share/nginx/html/ready"]
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 5
          failureThreshold: 2
          successThreshold: 1
---
apiVersion: v1
kind: Service
metadata:
  name: readiness-svc
spec:
  selector:
    app: readiness-demo
  ports:
  - port: 80
EOF
kubectl apply -f readiness-demo.yaml
kubectl rollout status deployment/readiness-demo --timeout=60s
```{{execute}}

```bash
# All 3 pods are in endpoints
kubectl get endpoints readiness-svc
echo ""
echo "All 3 pods receive traffic"
```{{execute}}

```bash
# Break readiness on pod 1
POD1=$(kubectl get pod -l app=readiness-demo -o jsonpath='{.items[0].metadata.name}')
echo "Breaking readiness on: $POD1"
kubectl exec $POD1 -- rm /usr/share/nginx/html/ready
```{{execute}}

```bash
# Wait for probe to detect failure
sleep 15
echo "=== Endpoints after readiness failure ==="
kubectl get endpoints readiness-svc
echo ""
echo "Pod was removed from endpoints - no traffic goes to broken pod"
echo ""
kubectl get pods -l app=readiness-demo
echo ""
echo "Pod is still RUNNING - readiness does NOT restart"
```{{execute}}

```bash
# Fix readiness - pod returns to endpoints automatically
POD1=$(kubectl get pod -l app=readiness-demo -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD1 -- sh -c "echo OK > /usr/share/nginx/html/ready"
sleep 10
echo "=== Endpoints after fix ==="
kubectl get endpoints readiness-svc
```{{execute}}
