# Шаг 4: Используем PVC в поде — данные переживают рестарт

## Монтируем PVC в под

```bash
cat > pod-with-pvc.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pvc-writer
spec:
  volumes:
  - name: persistent-storage
    persistentVolumeClaim:
      claimName: pvc-demo      # Имя нашего PVC
  containers:
  - name: writer
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Persistent data: pod started at $(date)" >> /mnt/data/log.txt
      sleep 3600
    volumeMounts:
    - name: persistent-storage
      mountPath: /mnt/data
EOF
kubectl apply -f pod-with-pvc.yaml
kubectl wait --for=condition=Ready pod/pvc-writer --timeout=60s
```{{execute}}

```bash
# Данные записаны
kubectl exec pvc-writer -- cat /mnt/data/log.txt
```{{execute}}

```bash
# Удаляем под — PVC и данные остаются
kubectl delete pod pvc-writer
kubectl get pvc pvc-demo   # PVC всё ещё Bound
```{{execute}}

```bash
# Создаём НОВЫЙ под с тем же PVC
cat > pod-with-pvc-2.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pvc-reader
spec:
  volumes:
  - name: persistent-storage
    persistentVolumeClaim:
      claimName: pvc-demo
  containers:
  - name: reader
    image: busybox
    command:
    - sh
    - -c
    - |
      echo 'New pod reads old data:'
      cat /mnt/data/log.txt
      echo "New pod appended at $(date)" >> /mnt/data/log.txt
      sleep 3600
    volumeMounts:
    - name: persistent-storage
      mountPath: /mnt/data
EOF
kubectl apply -f pod-with-pvc-2.yaml
kubectl wait --for=condition=Ready pod/pvc-reader --timeout=60s
```{{execute}}

```bash
# Новый под видит данные от старого!
kubectl exec pvc-reader -- cat /mnt/data/log.txt | tee /root/pvc_persistence.log
```{{execute}}

```bash
# Данные физически хранятся на узле
NODE=$(kubectl get pod pvc-reader -o jsonpath='{.spec.nodeName}')
echo "Под запущен на узле: $NODE"
echo "Данные в hostPath /data/pv-1:"
kubectl exec pvc-reader -- ls -la /mnt/data/
```{{execute}}

```bash
kubectl delete pod pvc-reader
```{{execute}}
