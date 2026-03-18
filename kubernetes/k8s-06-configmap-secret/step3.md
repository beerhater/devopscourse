# Шаг 3: Передача в под через переменные окружения

## Отдельные переменные из ConfigMap

```bash
cat > pod-env.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: app-env-demo
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "env | sort && sleep 3600"]
    env:
    - name: APP_ENV           # Имя переменной в контейнере
      valueFrom:
        configMapKeyRef:
          name: app-config    # Имя ConfigMap
          key: APP_ENV        # Ключ внутри ConfigMap
    - name: APP_PORT
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_PORT
    - name: DB_PASSWORD       # Из Secret
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: DB_PASSWORD
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: DB_USER
EOF
kubectl apply -f pod-env.yaml
kubectl wait --for=condition=Ready pod/app-env-demo --timeout=30s
```{{execute}}

```bash
# Смотрим переменные в контейнере
kubectl exec app-env-demo -- env | grep -E 'APP_|DB_'
```{{execute}}

## envFrom — все ключи сразу

```bash
cat > pod-envfrom.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: app-envfrom-demo
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "env | sort && sleep 3600"]
    envFrom:
    - configMapRef:
        name: app-config      # Все ключи CM → переменные окружения
    - secretRef:
        name: db-credentials  # Все ключи Secret → переменные окружения
    - configMapRef:
        name: web-config
        optional: true        # Не упасть если CM не существует
EOF
kubectl apply -f pod-envfrom.yaml
kubectl wait --for=condition=Ready pod/app-envfrom-demo --timeout=30s
```{{execute}}

```bash
# Видим все переменные из CM и Secret
kubectl exec app-envfrom-demo -- env | grep -vE '^(PATH|HOME|HOSTNAME|KUBERNETES)'
```{{execute}}

```bash
# Важно: env-переменные НЕ обновляются при изменении ConfigMap!
# Под нужно перезапустить. Это ограничение подхода через env.
kubectl delete pod app-env-demo app-envfrom-demo
```{{execute}}
