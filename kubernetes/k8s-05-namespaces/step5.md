# Шаг 5: ResourceQuota — лимиты на namespace

`ResourceQuota` ограничивает суммарные ресурсы в namespace: CPU, RAM, количество объектов.

## Создаём квоты

```bash
cat > quota.yaml << 'EOF'
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: development
spec:
  hard:
    # Вычислительные ресурсы
    requests.cpu: "2"           # Суммарный CPU requests всех подов
    requests.memory: 2Gi        # Суммарная память requests
    limits.cpu: "4"             # Суммарный CPU limits
    limits.memory: 4Gi          # Суммарная память limits
    # Количество объектов
    pods: "10"                  # Максимум подов
    services: "5"
    deployments.apps: "5"
    secrets: "10"
    configmaps: "10"
    persistentvolumeclaims: "5"
EOF
kubectl apply -f quota.yaml
```{{execute}}

```bash
kubectl describe resourcequota dev-quota -n development
```{{execute}}

## Проверяем квоту в действии

```bash
# При включённой ResourceQuota поды ОБЯЗАНЫ иметь resource requests/limits
cat > quota-test.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quota-test
  namespace: development
spec:
  replicas: 2
  selector:
    matchLabels:
      app: quota-test
  template:
    metadata:
      labels:
        app: quota-test
    spec:
      containers:
      - name: web
        image: nginx:alpine
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
EOF
kubectl apply -f quota-test.yaml
kubectl rollout status deployment/quota-test -n development
```{{execute}}

```bash
# Обновлённое состояние квоты
kubectl describe resourcequota dev-quota -n development
```{{execute}}

## LimitRange — дефолтные лимиты для подов

```bash
cat > limitrange.yaml << 'EOF'
apiVersion: v1
kind: LimitRange
metadata:
  name: dev-limits
  namespace: staging
spec:
  limits:
  - type: Container
    default:             # Дефолтные limits если не указаны
      cpu: "200m"
      memory: "128Mi"
    defaultRequest:      # Дефолтные requests если не указаны
      cpu: "100m"
      memory: "64Mi"
    max:                 # Потолок — нельзя указать больше
      cpu: "1"
      memory: "512Mi"
    min:                 # Пол — нельзя указать меньше
      cpu: "50m"
      memory: "32Mi"
EOF
kubectl apply -f limitrange.yaml
kubectl describe limitrange dev-limits -n staging
```{{execute}}

```bash
# Теперь поды в staging автоматически получают дефолтные лимиты
kubectl create deployment auto-limits --image=nginx:alpine -n staging
sleep 3
kubectl get pod -n staging -o jsonpath='{.items[0].spec.containers[0].resources}' | python3 -m json.tool
```{{execute}}
