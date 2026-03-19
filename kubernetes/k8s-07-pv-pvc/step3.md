# Шаг 3: PersistentVolumeClaim — запрашиваем хранилище

**PVC** — запрос пода на хранилище. K8s ищет подходящий PV и связывает их (Binding).

## Создаём PVC

```bash
cat > pvc-demo.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-demo
spec:
  storageClassName: ""      # Пустая строка — ищем PV без StorageClass
  accessModes:
  - ReadWriteOnce           # Должен совпадать с PV
  resources:
    requests:
      storage: 500Mi        # Запрашиваем 500Mi — подойдёт pv-hostpath-1 (1Gi >= 500Mi)
EOF
kubectl apply -f pvc-demo.yaml
```{{execute}}

```bash
# Сразу после создания PVC должен перейти в Bound
kubectl get pvc pvc-demo
```{{execute}}

```bash
kubectl describe pvc pvc-demo
```{{execute}}

```bash
# Смотрим — PV теперь тоже Bound
kubectl get pv pv-hostpath-1
```{{execute}}

## Правила Binding

K8s выбирает PV по:
1. `storageClassName` — должен совпадать
2. `accessModes` — PV должен поддерживать все запрошенные режимы
3. `storage` — PV capacity >= PVC request
4. `selector` (опционально) — label-селектор PVC

```bash
# Второй PVC — запрашивает больше чем есть в pv-hostpath-2
cat > pvc-no-match.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-no-match
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi          # Нет подходящего PV — останется Pending
EOF
kubectl apply -f pvc-no-match.yaml
sleep 3
kubectl get pvc pvc-no-match
```{{execute}}

```bash
# Pending — нет PV с 2Gi и storageClassName=""
kubectl describe pvc pvc-no-match | grep -A5 "Events:"
kubectl delete pvc pvc-no-match
```{{execute}}
