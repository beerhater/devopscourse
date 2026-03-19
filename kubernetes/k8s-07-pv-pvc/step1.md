# Шаг 1: Проблема — данные пропадают при рестарте пода

Покажем проблему на практике, затем решим её через PVC.

## Данные без PV — теряются

```bash
kubectl run ephemeral --image=busybox --restart=Never \
  -- sh -c "echo 'Important data v1' > /data/file.txt && sleep 3600" 2>/dev/null || true
kubectl run ephemeral --image=busybox --restart=Never \
  --command -- sh -c "mkdir -p /data && echo 'Important data v1' > /data/file.txt && sleep 3600"
kubectl wait --for=condition=Ready pod/ephemeral --timeout=30s
```{{execute}}

```bash
# Данные есть пока под живёт
kubectl exec ephemeral -- cat /data/file.txt
```{{execute}}

```bash
# Убиваем под
kubectl delete pod ephemeral --grace-period=0
```{{execute}}

```bash
# Пересоздаём с тем же именем — данных нет
kubectl run ephemeral --image=busybox --restart=Never \
  --command -- sh -c "mkdir -p /data && sleep 3600"
kubectl wait --for=condition=Ready pod/ephemeral --timeout=30s
kubectl exec ephemeral -- ls /data/ || echo "Директория пуста — данных нет!"
```{{execute}}

```bash
kubectl delete pod ephemeral
```{{execute}}

## emptyDir — данные живут пока живёт под

`emptyDir` — временное хранилище: данные есть пока Pod не удалён (переживает restart контейнера, но не удаление пода).

```bash
cat > emptydir-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-demo
spec:
  volumes:
  - name: temp-storage
    emptyDir: {}
  containers:
  - name: writer
    image: busybox
    command: ["sh", "-c", "echo 'emptyDir data' > /tmp/data/file.txt && sleep 3600"]
    volumeMounts:
    - name: temp-storage
      mountPath: /tmp/data
  - name: reader
    image: busybox
    command: ["sh", "-c", "sleep 5 && cat /tmp/data/file.txt && sleep 3600"]
    volumeMounts:
    - name: temp-storage
      mountPath: /tmp/data
EOF
kubectl apply -f emptydir-pod.yaml
kubectl wait --for=condition=Ready pod/emptydir-demo --timeout=30s
```{{execute}}

```bash
# Оба контейнера видят одни данные через emptyDir
kubectl logs emptydir-demo -c reader
kubectl delete pod emptydir-demo
```{{execute}}
