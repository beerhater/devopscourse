# Шаг 8: Паттерны использования namespace в продакшне

Как namespace используют в реальных компаниях.

## Паттерн 1: По окружению

```
default      → legacy / ручные эксперименты
development  → ветка dev, деплой при каждом commit
staging      → RC-версии, тестирование перед релизом
production   → только стабильные релизы
```

## Паттерн 2: По командам

```
team-backend     → микросервисы бэкенда
team-frontend    → UI приложения
team-data        → ETL, Kafka, ClickHouse
team-infra       → мониторинг, логи, трейсинг
```

## Паттерн 3: По проектам (tenant-изоляция)

```
client-acme      → ресурсы клиента A
client-globex    → ресурсы клиента B
client-initech   → ресурсы клиента C
```

## Создадим реалистичную структуру

```bash
cat > project-namespaces.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: app-dev
  labels:
    env: development
    project: myapp
---
apiVersion: v1
kind: Namespace
metadata:
  name: app-staging
  labels:
    env: staging
    project: myapp
---
apiVersion: v1
kind: Namespace
metadata:
  name: app-prod
  labels:
    env: production
    project: myapp
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: app-dev
spec:
  hard:
    pods: "20"
    requests.cpu: "4"
    requests.memory: 4Gi
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: prod-quota
  namespace: app-prod
spec:
  hard:
    pods: "100"
    requests.cpu: "20"
    requests.memory: 40Gi
EOF
kubectl apply -f project-namespaces.yaml
```{{execute}}

```bash
kubectl get namespaces --show-labels | grep myapp
kubectl get resourcequotas -A | grep quota
```{{execute}}

## Просмотр ресурсов по всем namespace

```bash
# Все поды кластера
kubectl get pods -A
```{{execute}}

```bash
# Все деплойменты с namespace
kubectl get deployments -A
```{{execute}}

```bash
# Краткая сводка по кластеру
kubectl get all -A | grep -v "^kube-" | head -40
```{{execute}}
