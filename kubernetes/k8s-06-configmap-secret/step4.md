# Шаг 4: Монтирование как Volume — файлы в контейнере

При монтировании через volume ConfigMap обновляется **автоматически** (через ~1 минуту) без перезапуска пода.

## Монтируем ConfigMap как файлы

```bash
cat > pod-volume.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: app-volume-demo
spec:
  volumes:
  - name: config-volume
    configMap:
      name: nginx-configs          # Каждый ключ → отдельный файл
  - name: web-config-volume
    configMap:
      name: web-config
      items:                       # Монтируем только конкретные ключи
      - key: nginx.conf
        path: nginx.conf           # Имя файла в контейнере
      - key: config.json
        path: config/app.json      # Можно в поддиректорию
  containers:
  - name: nginx
    image: nginx:alpine
    volumeMounts:
    - name: config-volume
      mountPath: /etc/app-configs  # Директория с файлами из CM
    - name: web-config-volume
      mountPath: /etc/nginx/conf.d # Файл nginx.conf попадёт сюда
EOF
kubectl apply -f pod-volume.yaml
kubectl wait --for=condition=Ready pod/app-volume-demo --timeout=30s
```{{execute}}

```bash
# Видим файлы примонтированного ConfigMap
kubectl exec app-volume-demo -- ls /etc/app-configs/
```{{execute}}

```bash
kubectl exec app-volume-demo -- cat /etc/app-configs/nginx.conf
```{{execute}}

```bash
kubectl exec app-volume-demo -- cat /etc/nginx/conf.d/nginx.conf
```{{execute}}

## Монтируем Secret как файлы

```bash
cat > pod-secret-volume.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: app-secret-volume
spec:
  volumes:
  - name: db-creds
    secret:
      secretName: db-credentials
      defaultMode: 0400          # Права только на чтение владельцем
  - name: tls-certs
    secret:
      secretName: myapp-tls
      items:
      - key: tls.crt
        path: server.crt
      - key: tls.key
        path: server.key
        mode: 0400               # Ключ — максимально ограниченные права
  containers:
  - name: app
    image: busybox
    command: ["sleep", "3600"]
    volumeMounts:
    - name: db-creds
      mountPath: /etc/secrets/db
      readOnly: true
    - name: tls-certs
      mountPath: /etc/tls
      readOnly: true
EOF
kubectl apply -f pod-secret-volume.yaml
kubectl wait --for=condition=Ready pod/app-secret-volume --timeout=30s
```{{execute}}

```bash
# Файлы Secret примонтированы с правильными правами
kubectl exec app-secret-volume -- ls -la /etc/secrets/db/
kubectl exec app-secret-volume -- cat /etc/secrets/db/DB_PASSWORD
echo ""
```{{execute}}

```bash
kubectl exec app-secret-volume -- ls -la /etc/tls/
```{{execute}}
