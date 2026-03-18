# Шаг 8: Docker Registry Secret и передача в Deployment

При использовании приватного registry поду нужны credentials для pull образа.

## Создаём registry secret

```bash
# Формат для Docker Hub / любого registry
kubectl create secret docker-registry registry-creds   --docker-server=registry.example.com   --docker-username=myuser   --docker-password=mypassword   --docker-email=me@example.com
```{{execute}}

```bash
kubectl get secret registry-creds
kubectl describe secret registry-creds
```{{execute}}

```bash
# Смотрим структуру внутри
kubectl get secret registry-creds   -o jsonpath='{.data.\.dockerconfigjson}' | base64 -d | python3 -m json.tool
```{{execute}}

## Используем в Deployment

```bash
cat > private-deploy.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: private-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: private-app
  template:
    metadata:
      labels:
        app: private-app
    spec:
      imagePullSecrets:
      - name: registry-creds    # Используем для pull образа
      containers:
      - name: app
        image: registry.example.com/myorg/myapp:1.0.0
        env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: DB_PASSWORD
        - name: API_TOKEN
          valueFrom:
            secretKeyRef:
              name: api-credentials
              key: API_TOKEN
EOF
# Применяем (образ не существует — это демонстрация манифеста)
cat private-deploy.yaml
```{{execute}}

## Автоматический pull secret через ServiceAccount

```bash
# Привязать secret к default ServiceAccount в namespace
# Тогда все поды автоматически используют его для pull
kubectl patch serviceaccount default   -p '{"imagePullSecrets": [{"name": "registry-creds"}]}'

kubectl get serviceaccount default -o yaml | grep -A5 imagePullSecrets
```{{execute}}

```bash
# Откатываем изменение SA
kubectl patch serviceaccount default --type=json   -p='[{"op":"remove","path":"/imagePullSecrets"}]' 2>/dev/null || true
```{{execute}}
