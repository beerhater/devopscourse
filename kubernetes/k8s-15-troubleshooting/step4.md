# Шаг 4: Создаём pod с CrashLoopBackOff

Для сравнения создадим другой тип проблемы: контейнер запускается и сразу падает.

```bash
cat > /root/crashloop-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: crash-demo
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "echo crash-loop && exit 1"]
EOF

kubectl apply -f /root/crashloop-pod.yaml
sleep 15
kubectl get pod crash-demo -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}' > /root/crash_reason.txt
cat /root/crash_reason.txt
```{{execute}}
