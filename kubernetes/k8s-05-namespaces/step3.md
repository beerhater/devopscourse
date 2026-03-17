# Шаг 3: kubectl config set-context — переключение namespace

Каждый раз писать `-n development` неудобно. `kubectl config set-context` меняет namespace по умолчанию для текущего контекста.

## Смотрим текущую конфигурацию

```bash
kubectl config view --minify
```{{execute}}

```bash
# Текущий контекст
kubectl config current-context
```{{execute}}

## Меняем namespace по умолчанию

```bash
# Синтаксис: kubectl config set-context --current --namespace=<NS>
kubectl config set-context --current --namespace=development
```{{execute}}

```bash
# Теперь все команды без -n работают в development
kubectl get deployments
kubectl get pods
```{{execute}}

```bash
# Контекст изменился — в колонке NAMESPACE теперь development
kubectl config get-contexts
```{{execute}}

## Возвращаемся в default

```bash
kubectl config set-context --current --namespace=default
kubectl get deployments  # снова пусто (в default ничего нет)
```{{execute}}

## Полный контроль: именованные контексты

```bash
# Создаём отдельные контексты для каждого namespace
CLUSTER=$(kubectl config current-context)

kubectl config set-context dev-context   --cluster=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')   --user=$(kubectl config view --minify -o jsonpath='{.users[0].name}')   --namespace=development

kubectl config set-context staging-context   --cluster=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')   --user=$(kubectl config view --minify -o jsonpath='{.users[0].name}')   --namespace=staging
```{{execute}}

```bash
kubectl config get-contexts
```{{execute}}

```bash
# Переключаемся
kubectl config use-context dev-context
kubectl get pods     # автоматически в development
```{{execute}}

```bash
kubectl config use-context staging-context
kubectl get pods     # автоматически в staging
```{{execute}}

```bash
# Возвращаемся к основному контексту
kubectl config use-context $(kubectl config get-contexts | grep '\*' | awk '{print $2}' | head -1 || echo "kubernetes-admin@kubernetes")
kubectl config set-context --current --namespace=default
```{{execute}}
