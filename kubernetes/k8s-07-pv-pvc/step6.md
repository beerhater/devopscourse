# Шаг 6: Reclaim Policy — что происходит при удалении PVC

**Reclaim Policy** определяет судьбу PV после удаления связанного PVC.

| Политика | Что происходит с PV | Что происходит с данными |
|----------|--------------------|-----------------------|
| `Retain` | Остаётся в статусе `Released` | Сохраняются, нужна ручная очистка |
| `Delete` | PV удаляется | Данные удаляются |
| `Recycle` | Данные очищаются (`rm -rf`) | Теряются (устарело, не рекомендуется) |

## Демонстрация Retain

```bash
# Создаём PV с Retain политикой
cat > pv-retain.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-retain-demo
spec:
  storageClassName: ""
  capacity:
    storage: 100Mi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/pv-retain
    type: DirectoryOrCreate
EOF
kubectl apply -f pv-retain.yaml
```{{execute}}

```bash
cat > pvc-retain.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-retain
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 50Mi
EOF
kubectl apply -f pvc-retain.yaml
kubectl get pv pv-retain-demo
```{{execute}}

```bash
# Записываем данные
kubectl run retain-test --image=busybox --restart=Never \
  --overrides='{
    "spec": {
      "volumes": [{"name":"data","persistentVolumeClaim":{"claimName":"pvc-retain"}}],
      "containers": [{"name":"c","image":"busybox",
        "command":["sh","-c","echo retain-test-data > /mnt/keep.txt && sleep 2"],
        "volumeMounts":[{"name":"data","mountPath":"/mnt"}]
      }]
    }
  }'
sleep 5
kubectl logs retain-test 2>/dev/null; true
kubectl delete pod retain-test
```{{execute}}

```bash
# Удаляем PVC
kubectl delete pvc pvc-retain
```{{execute}}

```bash
# PV перешёл в Released — данные СОХРАНИЛИСЬ
kubectl get pv pv-retain-demo
```{{execute}}

```bash
# Чтобы переиспользовать Retain PV — нужно убрать claimRef вручную
kubectl patch pv pv-retain-demo \
  --type=json \
  -p='[{"op":"remove","path":"/spec/claimRef"}]'

kubectl get pv pv-retain-demo   # Теперь снова Available
```{{execute}}

## Демонстрация Delete

```bash
cat > pv-delete-demo.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-delete-demo
spec:
  storageClassName: ""
  capacity:
    storage: 100Mi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  hostPath:
    path: /data/pv-delete
    type: DirectoryOrCreate
EOF
kubectl apply -f pv-delete-demo.yaml
```{{execute}}

```bash
cat > pvc-delete.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-delete
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 50Mi
EOF
kubectl apply -f pvc-delete.yaml
kubectl get pv pv-delete-demo
```{{execute}}

```bash
# Удаляем PVC — PV с политикой Delete тоже удалится
kubectl delete pvc pvc-delete
sleep 2
kubectl get pv pv-delete-demo 2>/dev/null || echo "PV удалён вместе с PVC (политика Delete)"
```{{execute}}
