# Шаг 6: Multi-container Pod и Init-контейнеры

## Sidecar-паттерн

Два контейнера делят один volume:

```bash
cat > sidecar-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-demo
spec:
  volumes:
  - name: shared-logs
    emptyDir: {}
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      while true; do
        echo "$(date): running" | tee -a /logs/app.log
        sleep 3
      done
    volumeMounts:
    - name: shared-logs
      mountPath: /logs
  - name: log-reader
    image: busybox
    command:
    - sh
    - -c
    - |
      touch /logs/app.log
      tail -f /logs/app.log
    volumeMounts:
    - name: shared-logs
      mountPath: /logs
EOF
kubectl apply -f sidecar-pod.yaml
```{{execute}}

```bash
sleep 6
kubectl logs sidecar-demo -c app
kubectl logs sidecar-demo -c log-reader
```{{execute}}

## Init-контейнер

Выполняется до основного. Используется для ожидания зависимостей, миграций БД.

```bash
cat > init-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: init-demo
spec:
  initContainers:
  - name: wait-for-setup
    image: busybox
    command:
    - sh
    - -c
    - |
      echo 'Init: preparing...'
      sleep 5
      echo 'Init: done!'
  containers:
  - name: main-app
    image: busybox
    command:
    - sh
    - -c
    - |
      echo 'Main app started after init!'
      sleep 3600
EOF
kubectl apply -f init-pod.yaml
```{{execute}}

```bash
kubectl get pod init-demo -w
```{{execute}}

Нажмите `Ctrl+C` когда под перейдёт в `Running`.

```bash
kubectl logs init-demo -c wait-for-setup
kubectl logs init-demo -c main-app
```{{execute}}
