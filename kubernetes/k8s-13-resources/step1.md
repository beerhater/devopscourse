# Шаг 1: Создаём pod с requests и limits

Создайте pod с явными лимитами по CPU и памяти и сохраните описание.

```bash
cat > /root/resource-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
    - name: app
      image: nginx:1.27-alpine
      resources:
        requests:
          cpu: "100m"
          memory: "64Mi"
        limits:
          cpu: "200m"
          memory: "128Mi"
EOF

kubectl apply -f /root/resource-pod.yaml
kubectl wait --for=condition=Ready pod/resource-demo --timeout=120s
kubectl describe pod resource-demo > /root/resource_pod_describe.txt
kubectl get pod resource-demo -o jsonpath='{.spec.containers[0].resources.requests.cpu} {.spec.containers[0].resources.limits.memory}' > /root/resource_values.txt

cat /root/resource_values.txt
```{{execute}}

Эта практика очень логично продолжает тему Docker resource limits, но уже на уровне Kubernetes.
