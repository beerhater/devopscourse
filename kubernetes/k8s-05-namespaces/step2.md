# Шаг 2: Создание namespace и базовая работа

## Создать namespace

```bash
# Императивно
kubectl create namespace development
kubectl create namespace staging
kubectl create namespace production
```{{execute}}

```bash
kubectl get namespaces
```{{execute}}

## YAML-манифест namespace

```bash
cat > namespaces.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: team-backend
  labels:
    team: backend
    env: dev
---
apiVersion: v1
kind: Namespace
metadata:
  name: team-frontend
  labels:
    team: frontend
    env: dev
EOF
kubectl apply -f namespaces.yaml
kubectl get namespaces --show-labels
```{{execute}}

## Создаём ресурсы в конкретном namespace

```bash
# Флаг -n / --namespace
kubectl create deployment nginx --image=nginx:alpine -n development
kubectl create deployment apache --image=httpd:alpine -n staging
```{{execute}}

```bash
# Ресурсы изолированы — в default их нет
kubectl get deployments
```{{execute}}

```bash
kubectl get deployments -n development
kubectl get deployments -n staging
```{{execute}}

```bash
# Посмотреть ВСЕ namespace сразу
kubectl get deployments --all-namespaces
# или короче
kubectl get deployments -A
```{{execute}}

## Describe namespace

```bash
kubectl describe namespace development
```{{execute}}
