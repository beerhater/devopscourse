# Шаг 5: Access Modes — режимы доступа

Режим доступа определяет как узлы кластера могут монтировать том.

| Режим | Сокращение | Описание |
|-------|-----------|----------|
| `ReadWriteOnce` | RWO | Один узел — чтение и запись |
| `ReadOnlyMany` | ROX | Много узлов — только чтение |
| `ReadWriteMany` | RWX | Много узлов — чтение и запись |
| `ReadWriteOncePod` | RWOP | Один под — чтение и запись (K8s 1.22+) |

> `hostPath` поддерживает только `RWO` — привязан к конкретному узлу.
> `RWX` обычно требует NFS, CephFS, GlusterFS или облачное хранилище.

## ReadWriteOnce — стандарт для баз данных

```bash
cat > pv-rwo.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-rwo
spec:
  storageClassName: ""
  capacity:
    storage: 200Mi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: /data/pv-rwo
    type: DirectoryOrCreate
  persistentVolumeReclaimPolicy: Delete
EOF
kubectl apply -f pv-rwo.yaml
```{{execute}}

```bash
cat > pvc-rwo.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-rwo
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
EOF
kubectl apply -f pvc-rwo.yaml
kubectl get pvc pvc-rwo
```{{execute}}

## RWO ограничение: второй под на ДРУГОМ узле не может примонтировать

```bash
# Два пода с RWO PVC — работают только если на одном узле
cat > two-pods-rwo.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: rwo-pod-1
spec:
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: pvc-rwo
  containers:
  - name: app
    image: busybox
    command: ["sleep", "3600"]
    volumeMounts:
    - name: data
      mountPath: /data
EOF
kubectl apply -f two-pods-rwo.yaml
kubectl wait --for=condition=Ready pod/rwo-pod-1 --timeout=30s
echo "Pod 1 запущен на узле: $(kubectl get pod rwo-pod-1 -o jsonpath='{.spec.nodeName}')"
```{{execute}}

```bash
# Проверяем access mode у примонтированного PV
kubectl get pv $(kubectl get pvc pvc-rwo -o jsonpath='{.spec.volumeName}') -o jsonpath='{.spec.accessModes}'
echo ""
```{{execute}}

## ReadOnlyMany — общий конфиг для многих подов

```bash
cat > pv-rox.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-rox
spec:
  storageClassName: ""
  capacity:
    storage: 100Mi
  accessModes:
  - ReadOnlyMany              # Много подов на разных узлах могут читать
  hostPath:
    path: /data/pv-rox
    type: DirectoryOrCreate
  persistentVolumeReclaimPolicy: Delete
EOF
kubectl apply -f pv-rox.yaml
```{{execute}}

```bash
cat > pvc-rox.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-rox
spec:
  storageClassName: ""
  accessModes:
  - ReadOnlyMany
  resources:
    requests:
      storage: 50Mi
EOF
kubectl apply -f pvc-rox.yaml
kubectl get pv,pvc | grep -E 'NAME|pv-ro|pvc-ro'
```{{execute}}

```bash
kubectl delete pod rwo-pod-1
```{{execute}}
