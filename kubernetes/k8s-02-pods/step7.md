# Шаг 7: Итоговое задание

```bash
cat > final-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: final-app
  labels:
    app: final
    env: practice
spec:
  initContainers:
  - name: init-check
    image: busybox
    command:
    - sh
    - -c
    - |
      echo 'Pre-flight check...'
      sleep 2
      echo 'OK'
  containers:
  - name: web
    image: nginx:alpine
    ports:
    - containerPort: 80
    resources:
      requests:
        memory: "16Mi"
        cpu: "25m"
      limits:
        memory: "32Mi"
        cpu: "50m"
  - name: sidecar
    image: busybox
    command:
    - sh
    - -c
    - |
      while true; do
        echo "$(date): monitoring"
        sleep 10
      done
    resources:
      requests:
        memory: "8Mi"
        cpu: "10m"
EOF
kubectl apply -f final-pod.yaml
```{{execute}}

```bash
kubectl get pods -w
```{{execute}}

Нажмите `Ctrl+C` когда `final-app` будет `Running`.

```bash
kubectl describe pod final-app
```{{execute}}

```bash
kubectl logs final-app -c init-check
kubectl logs final-app -c web
kubectl logs final-app -c sidecar
```{{execute}}

```bash
kubectl get pod final-app -o jsonpath='{.status.podIP}' && echo ""
kubectl get pods -l app=final
kubectl get pods -l env=practice
```{{execute}}

```bash
kubectl exec final-app -c web -- nginx -v
```{{execute}}
