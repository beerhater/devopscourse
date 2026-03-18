# Шаг 6: Реальный пример — nginx с ConfigMap

Полноценный пример: Deployment с nginx, конфиг которого живёт в ConfigMap.

```bash
cat > nginx-full.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-custom-config
data:
  default.conf: |
    server {
        listen 80;
        server_name _;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }

        location /api/ {
            proxy_pass http://backend-svc:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /health {
            access_log off;
            return 200 'healthy
';
            add_header Content-Type text/plain;
        }
    }
  index.html: |
    <!DOCTYPE html>
    <html>
    <head><title>My App</title></head>
    <body>
      <h1>Configured via ConfigMap!</h1>
      <p>Environment: production</p>
    </body>
    </html>
---
apiVersion: v1
kind: Secret
metadata:
  name: nginx-auth
type: Opaque
stringData:
  htpasswd: "admin:$apr1$xyz$hashedpassword"
  admin-token: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-configured
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-configured
  template:
    metadata:
      labels:
        app: nginx-configured
    spec:
      volumes:
      - name: nginx-conf
        configMap:
          name: nginx-custom-config
          items:
          - key: default.conf
            path: default.conf
      - name: nginx-html
        configMap:
          name: nginx-custom-config
          items:
          - key: index.html
            path: index.html
      - name: auth-secret
        secret:
          secretName: nginx-auth
          defaultMode: 0400
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_ENV
        volumeMounts:
        - name: nginx-conf
          mountPath: /etc/nginx/conf.d
        - name: nginx-html
          mountPath: /usr/share/nginx/html
        - name: auth-secret
          mountPath: /etc/nginx/auth
          readOnly: true
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
EOF
kubectl apply -f nginx-full.yaml
kubectl rollout status deployment/nginx-configured
```{{execute}}

```bash
# Проверяем что конфиг применился
POD=$(kubectl get pods -l app=nginx-configured -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD -- cat /etc/nginx/conf.d/default.conf
```{{execute}}

```bash
kubectl exec $POD -- cat /usr/share/nginx/html/index.html
```{{execute}}

```bash
# Запрос к /health
kubectl exec $POD -- wget -qO- http://localhost/health
```{{execute}}
