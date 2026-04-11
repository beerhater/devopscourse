# Шаг 4: Создаём Guaranteed pod

Теперь создадим pod, где `requests` и `limits` совпадают.

```bash
cat > /root/guaranteed-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: guaranteed-demo
spec:
  containers:
    - name: app
      image: nginx:1.27-alpine
      resources:
        requests:
          cpu: "100m"
          memory: "64Mi"
        limits:
          cpu: "100m"
          memory: "64Mi"
EOF

kubectl apply -f /root/guaranteed-pod.yaml
kubectl wait --for=condition=Ready pod/guaranteed-demo --timeout=120s
kubectl get pod guaranteed-demo -o jsonpath='{.status.qosClass}' > /root/guaranteed_qos.txt
cat /root/guaranteed_qos.txt
```{{execute}}
