# Step 5: Probe types - exec and tcpSocket

Besides httpGet there are two more probe types.

## exec - run a command inside the container

Use when there is no HTTP endpoint (databases, CLI tools, workers).

```bash
cat > exec-probe.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: exec-probe-demo
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      touch /tmp/healthy
      echo "Started. Healthy file exists."
      sleep 3600
    livenessProbe:
      exec:
        command:
        - sh
        - -c
        - "test -f /tmp/healthy && test $(find /tmp/healthy -mmin -5 | wc -l) -gt 0"
      initialDelaySeconds: 5
      periodSeconds: 10
    readinessProbe:
      exec:
        command: ["test", "-f", "/tmp/healthy"]
      initialDelaySeconds: 3
      periodSeconds: 5
EOF
kubectl apply -f exec-probe.yaml
kubectl wait --for=condition=Ready pod/exec-probe-demo --timeout=30s
kubectl describe pod exec-probe-demo | grep -A4 'Liveness:\|Readiness:'
```{{execute}}

```bash
kubectl get pod exec-probe-demo
```{{execute}}

## tcpSocket - check if port is open

Use for databases, message queues, any TCP service without HTTP.

```bash
cat > tcp-probe.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: tcp-probe-demo
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
    livenessProbe:
      tcpSocket:
        port: 80                # Just checks if port 80 accepts connections
      initialDelaySeconds: 5
      periodSeconds: 10
    readinessProbe:
      tcpSocket:
        port: 80
      initialDelaySeconds: 3
      periodSeconds: 5
EOF
kubectl apply -f tcp-probe.yaml
kubectl wait --for=condition=Ready pod/tcp-probe-demo --timeout=30s
kubectl describe pod tcp-probe-demo | grep -A4 'Liveness:\|Readiness:'
```{{execute}}

## gRPC probe (K8s 1.24+)

```bash
cat << 'EOF'
# For gRPC services - uses standard health protocol
livenessProbe:
  grpc:
    port: 9090
    service: "liveness"    # optional service name for health check
  periodSeconds: 10
EOF
```{{execute}}

## When to use which probe type

```bash
cat << 'EOF'
httpGet    - REST APIs, web servers (nginx, app servers)
exec       - databases (pg_isready), file checks, custom scripts
tcpSocket  - raw TCP services, databases without HTTP
grpc       - gRPC microservices
EOF
```{{execute}}

```bash
kubectl delete pod exec-probe-demo tcp-probe-demo
```{{execute}}
