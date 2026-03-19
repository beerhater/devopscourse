# Шаг 2: PersistentVolume — создаём хранилище вручную

**PV** — кластерный ресурс (не привязан к namespace), описывает реальное хранилище.
`hostPath` монтирует директорию с узла — подходит для разработки и Killercoda.

## Создаём hostPath PV

```bash
cat > pv-hostpath.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-hostpath-1
  labels:
    type: local
spec:
  storageClassName: ""        # Пустая строка = ручное связывание, без StorageClass
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce             # Только один узел может писать одновременно
  persistentVolumeReclaimPolicy: Retain   # При удалении PVC — данные сохранятся
  hostPath:
    path: /data/pv-1          # Путь на узле
    type: DirectoryOrCreate   # Создать если не существует
EOF
kubectl apply -f pv-hostpath.yaml
```{{execute}}

```bash
kubectl get pv pv-hostpath-1
```{{execute}}

```bash
kubectl describe pv pv-hostpath-1
```{{execute}}

Статус `Available` — PV создан и ждёт запроса от PVC.

## Создаём второй PV — для демонстрации Retain и Delete политик

```bash
cat > pv-hostpath-2.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-hostpath-2
  labels:
    type: local
spec:
  storageClassName: ""
  capacity:
    storage: 500Mi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete   # При удалении PVC — PV тоже удалится
  hostPath:
    path: /data/pv-2
    type: DirectoryOrCreate
EOF
kubectl apply -f pv-hostpath-2.yaml
```{{execute}}

```bash
kubectl get pv
```{{execute}}

## Жизненный цикл PV

| Статус | Описание |
|--------|----------|
| `Available` | Свободен, ждёт привязки PVC |
| `Bound` | Привязан к PVC |
| `Released` | PVC удалён, данные ещё есть |
| `Failed` | Автоматическое восстановление не удалось |
