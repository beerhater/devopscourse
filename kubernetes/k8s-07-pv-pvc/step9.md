# Шаг 9: Итоговое задание

Создаём полноценное хранилище с нуля: PV → PVC → Deployment → проверяем persistence.

## 1. Создаём статический PV

```bash
cat > final-pv.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: final-pv
  labels:
    purpose: final-task
spec:
  storageClassName: ""
  capacity:
    storage: 300Mi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/final-task
    type: DirectoryOrCreate
EOF
kubectl apply -f final-pv.yaml
kubectl get pv final-pv
```{{execute}}

## 2. Создаём PVC

```bash
cat > final-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: final-pvc
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 200Mi
  selector:
    matchLabels:
      purpose: final-task    # Явно выбираем наш PV по label
EOF
kubectl apply -f final-pvc.yaml
kubectl get pvc final-pvc
```{{execute}}

## 3. Создаём Deployment с PVC

```bash
cat > final-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: final-app
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: final-app
  template:
    metadata:
      labels:
        app: final-app
    spec:
      volumes:
      - name: app-data
        persistentVolumeClaim:
          claimName: final-pvc
      containers:
      - name: app
        image: busybox
        command:
        - sh
        - -c
        - |
          COUNTER_FILE=/data/counter.txt
          COUNT=$(cat $COUNTER_FILE 2>/dev/null || echo 0)
          COUNT=$((COUNT + 1))
          echo $COUNT > $COUNTER_FILE
          echo "Pod start #$COUNT at $(date)" >> /data/history.log
          echo "This is start number: $COUNT"
          sleep 3600
        volumeMounts:
        - name: app-data
          mountPath: /data
        resources:
          requests:
            cpu: "50m"
            memory: "32Mi"
          limits:
            cpu: "100m"
            memory: "64Mi"
EOF
kubectl apply -f final-deployment.yaml
kubectl rollout status deployment/final-app --timeout=60s
```{{execute}}

## 4. Проверяем первый запуск

```bash
POD=$(kubectl get pod -l app=final-app -o jsonpath='{.items[0].metadata.name}')
kubectl logs $POD
```{{execute}}

## 5. Рестартуем и проверяем счётчик

```bash
kubectl rollout restart deployment/final-app
kubectl rollout status deployment/final-app --timeout=60s
```{{execute}}

```bash
POD=$(kubectl get pod -l app=final-app -o jsonpath='{.items[0].metadata.name}')
kubectl logs $POD
kubectl exec $POD -- cat /data/history.log
```{{execute}}

```bash
# Счётчик увеличился — данные пережили рестарт!
kubectl exec $POD -- cat /data/counter.txt
```{{execute}}

## 6. Итоговое состояние

```bash
kubectl get pv,pvc
kubectl describe pvc final-pvc | grep -E 'Status|Volume:|Capacity|Access'
```{{execute}}

## 7. Очистка

```bash
kubectl delete deployment final-app postgres
kubectl delete service postgres-svc
kubectl delete pvc final-pvc pvc-demo pvc-rwo pvc-rox pvc-dynamic postgres-data pvc-retain 2>/dev/null; true
kubectl delete pv final-pv pv-hostpath-1 pv-hostpath-2 pv-rwo pv-rox pv-retain-demo pv-delete-demo 2>/dev/null; true
kubectl delete secret postgres-secret 2>/dev/null; true
kubectl delete pod dynamic-pvc-pod 2>/dev/null; true
echo "Очистка завершена!"
```{{execute}}
