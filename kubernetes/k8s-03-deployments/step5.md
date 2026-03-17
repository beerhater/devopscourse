# Шаг 5: kubectl rollout — история и откат

`kubectl rollout` — главный инструмент для управления процессом обновления.

## История обновлений

```bash
kubectl rollout history deployment/web-app
```{{execute}}

```bash
# Детали конкретной ревизии
kubectl rollout history deployment/web-app --revision=1
kubectl rollout history deployment/web-app --revision=2
```{{execute}}

## Откат на предыдущую версию

```bash
# Текущий образ
kubectl get deployment web-app -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{execute}}

```bash
# Откат на предыдущую ревизию
kubectl rollout undo deployment/web-app
```{{execute}}

```bash
kubectl rollout status deployment/web-app
```{{execute}}

```bash
# Образ вернулся к предыдущему
kubectl get deployment web-app -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{execute}}

## Откат на конкретную ревизию

```bash
kubectl rollout history deployment/web-app
```{{execute}}

```bash
# Откат на ревизию 1 (самую первую)
kubectl rollout undo deployment/web-app --to-revision=1
kubectl rollout status deployment/web-app
```{{execute}}

```bash
kubectl get deployment web-app -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{execute}}

## Пауза и продолжение rollout

```bash
# Пауза — удобно при поэтапном обновлении
kubectl set image deployment/web-app nginx=nginx:1.27-alpine
kubectl rollout pause deployment/web-app
```{{execute}}

```bash
kubectl get pods -l app=web-app
```{{execute}}

```bash
# Продолжаем обновление
kubectl rollout resume deployment/web-app
kubectl rollout status deployment/web-app
```{{execute}}

## Аннотации для истории

По умолчанию история не содержит причин. Добавляем аннотацию `--record` (через `kubectl.kubernetes.io/last-applied-configuration`) или через `cause`:

```bash
kubectl annotate deployment web-app kubernetes.io/change-cause="update to nginx 1.27" --overwrite
kubectl rollout history deployment/web-app
```{{execute}}
