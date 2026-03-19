# Шаг 7: StorageClass — динамическое выделение PV

При статическом выделении администратор создаёт PV заранее. **StorageClass** автоматизирует это: PVC создаёт PV динамически через provisioner.

```
PVC создан → StorageClass provisioner → PV создаётся автоматически → Binding
```

## Смотрим доступные StorageClass

```bash
kubectl get storageclass
```{{execute}}

## Устанавливаем local-path-provisioner (если нет StorageClass)

```bash
SC_COUNT=$(kubectl get storageclass --no-headers 2>/dev/null | wc -l)
if [ "$SC_COUNT" -eq 0 ]; then
  echo "StorageClass не найден — устанавливаем local-path-provisioner..."
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.26/deploy/local-path-storage.yaml
  kubectl rollout status deployment/local-path-provisioner -n local-path-storage --timeout=60s
  echo "Установлен!"
else
  echo "StorageClass уже есть:"
  kubectl get storageclass
fi
```{{execute}}

```bash
kubectl get storageclass
```{{execute}}

## Создаём PVC с StorageClass (без ручного PV)

```bash
SC_NAME=$(kubectl get storageclass --no-headers | head -1 | awk '{print $1}')
echo "Используем StorageClass: $SC_NAME"
```{{execute}}

```bash
cat > pvc-dynamic.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-dynamic
spec:
  storageClassName: local-path    # Имя StorageClass
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 256Mi
EOF
kubectl apply -f pvc-dynamic.yaml
```{{execute}}

```bash
# PVC может быть Pending пока нет пода — local-path использует WaitForFirstConsumer
kubectl get pvc pvc-dynamic
```{{execute}}

```bash
# Создаём под — это триггер для provisioner
cat > pod-dynamic-pvc.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: dynamic-pvc-pod
spec:
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: pvc-dynamic
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "echo dynamic-storage-works > /data/test.txt && sleep 3600"]
    volumeMounts:
    - name: data
      mountPath: /data
EOF
kubectl apply -f pod-dynamic-pvc.yaml
kubectl wait --for=condition=Ready pod/dynamic-pvc-pod --timeout=60s
```{{execute}}

```bash
# PV создался автоматически!
kubectl get pv
kubectl get pvc pvc-dynamic
```{{execute}}

```bash
kubectl exec dynamic-pvc-pod -- cat /data/test.txt
```{{execute}}

## YAML манифест StorageClass

```bash
kubectl describe storageclass $(kubectl get sc --no-headers | head -1 | awk '{print $1}')
```{{execute}}
