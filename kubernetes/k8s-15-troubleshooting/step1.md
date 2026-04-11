# Шаг 1: Разбираем сломанный pod

Создайте pod с несуществующим образом и найдите причину проблемы.

```bash
cat > /root/broken-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: broken-demo
spec:
  containers:
    - name: app
      image: nginx:not-a-real-tag
EOF

kubectl apply -f /root/broken-pod.yaml
sleep 10

kubectl describe pod broken-demo > /root/broken_pod_describe.txt
grep -E 'ErrImagePull|ImagePullBackOff|Failed to pull image' /root/broken_pod_describe.txt > /root/broken_reason.txt || true

cat /root/broken_reason.txt
```{{execute}}

Такой разбор очень типичен:

- сначала `kubectl describe`;
- потом чтение events;
- затем уже исправление manifest или image tag.
