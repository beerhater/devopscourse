# Шаг 5: Автообновление конфига без перезапуска

Volume-монтирование ConfigMap обновляется автоматически — это главное преимущество перед `env`.

## Демонстрация живого обновления

```bash
# Создаём ConfigMap с начальным значением
kubectl create configmap live-config --from-literal=message="Hello, World v1"
```{{execute}}

```bash
cat > live-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: live-update-demo
spec:
  volumes:
  - name: config
    configMap:
      name: live-config
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "while true; do cat /config/message; echo ''; sleep 5; done"]
    volumeMounts:
    - name: config
      mountPath: /config
EOF
kubectl apply -f live-pod.yaml
kubectl wait --for=condition=Ready pod/live-update-demo --timeout=30s
```{{execute}}

```bash
# Под выводит начальное значение
kubectl logs live-update-demo --tail=3
```{{execute}}

```bash
# Обновляем ConfigMap
kubectl create configmap live-config   --from-literal=message="Hello, World v2 — UPDATED!"   --dry-run=client -o yaml | kubectl apply -f -
```{{execute}}

```bash
# Ждём ~15-30 секунд пока kubelet обновит файл
sleep 20
kubectl logs live-update-demo --tail=5
```{{execute}}

```bash
# Файл обновился — под не перезапускался!
kubectl exec live-update-demo -- cat /config/message
```{{execute}}

> **Важно**: Файл в volume обновляется автоматически. Но если приложение читает конфиг только при старте — нужен перезапуск. Nginx, например, нужно сделать `nginx -s reload`.

## Принудительный рестарт деплоймента при смене конфига

```bash
kubectl create deployment config-app --image=nginx:alpine
kubectl set env deployment/config-app   --from=configmap/app-config

# Стандартный паттерн: аннотация с хешем конфига
CONFIG_HASH=$(kubectl get configmap app-config -o yaml | sha256sum | cut -c1-8)
kubectl patch deployment config-app   -p "{"spec":{"template":{"metadata":{"annotations":{"configmap-hash":"$CONFIG_HASH"}}}}}"
kubectl rollout status deployment/config-app
```{{execute}}
