# Шаг 1: ConfigMap — создание разными способами

## Императивно: из литерала

```bash
kubectl create configmap app-config   --from-literal=APP_ENV=production   --from-literal=APP_PORT=8080   --from-literal=APP_LOG_LEVEL=info   --from-literal=DB_HOST=postgres.default.svc.cluster.local
```{{execute}}

```bash
kubectl get configmap app-config
kubectl describe configmap app-config
```{{execute}}

## Из файла

```bash
# Создаём конфиг-файл приложения
cat > app.properties << 'EOF'
database.url=jdbc:postgresql://postgres:5432/myapp
database.pool.size=10
cache.ttl=3600
feature.dark_mode=true
feature.beta=false
EOF

kubectl create configmap app-properties --from-file=app.properties
kubectl describe configmap app-properties
```{{execute}}

```bash
# Из директории — все файлы становятся ключами
mkdir -p configs
cat > configs/nginx.conf << 'EOF'
server {
    listen 80;
    server_name _;
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
    location /health {
        return 200 'ok';
    }
}
EOF
cat > configs/app.env << 'EOF'
APP_NAME=myapp
APP_VERSION=1.2.3
EOF

kubectl create configmap nginx-configs --from-file=configs/
kubectl describe configmap nginx-configs
```{{execute}}

## YAML-манифест

```bash
cat > configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-config
  labels:
    app: web
data:
  # Простые значения
  APP_ENV: "staging"
  APP_PORT: "3000"
  REDIS_HOST: "redis.default.svc.cluster.local"
  REDIS_PORT: "6379"
  # Многострочное значение — конфиг файл
  nginx.conf: |
    server {
        listen 3000;
        location / { proxy_pass http://localhost:8080; }
        location /metrics { return 403; }
    }
  config.json: |
    {
      "logLevel": "info",
      "maxConnections": 100,
      "timeout": 30
    }
EOF
kubectl apply -f configmap.yaml
kubectl get configmap web-config -o yaml
```{{execute}}
