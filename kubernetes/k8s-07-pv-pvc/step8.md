# Шаг 8: Deployment + PVC — паттерн stateful-приложения

Deployment с PVC — стандартный паттерн для stateful-приложений (БД, кеш, очередь).

> Важно: PVC с `ReadWriteOnce` может использовать только один под одновременно. Для БД это нормально. Для масштабируемых приложений используют StatefulSet.

## PostgreSQL с PVC

```bash
cat > postgres-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-data
spec:
  storageClassName: local-path
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 512Mi
EOF
kubectl apply -f postgres-pvc.yaml
```{{execute}}

```bash
cat > postgres-deploy.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
stringData:
  POSTGRES_DB: myapp
  POSTGRES_USER: admin
  POSTGRES_PASSWORD: secretpassword
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1           # Всегда 1 реплика при RWO PVC
  strategy:
    type: Recreate      # Recreate — иначе новый под не сможет примонтировать занятый PVC
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-data
      containers:
      - name: postgres
        image: postgres:15-alpine
        envFrom:
        - secretRef:
            name: postgres-secret
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
        readinessProbe:
          exec:
            command: ["pg_isready", "-U", "admin", "-d", "myapp"]
          initialDelaySeconds: 10
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-svc
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
EOF
kubectl apply -f postgres-deploy.yaml
echo "Ждём запуска PostgreSQL..."
kubectl rollout status deployment/postgres --timeout=90s
```{{execute}}

```bash
kubectl get pod -l app=postgres
kubectl get pvc postgres-data
```{{execute}}

```bash
# Пишем данные в PostgreSQL
PG_POD=$(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec $PG_POD -- psql -U admin -d myapp -c "
  CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, name TEXT, created_at TIMESTAMP DEFAULT NOW());
  INSERT INTO users (name) VALUES ('Alice'), ('Bob');
  SELECT * FROM users;
"
```{{execute}}

```bash
# Рестартуем под — данные должны остаться
kubectl rollout restart deployment/postgres
kubectl rollout status deployment/postgres --timeout=90s
```{{execute}}

```bash
# Новый под — старые данные
PG_POD=$(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec $PG_POD -- psql -U admin -d myapp -c "SELECT * FROM users;"
```{{execute}}

```bash
# Данные пережили рестарт деплоймента!
echo "Alice и Bob остались — PVC работает корректно"
```{{execute}}
