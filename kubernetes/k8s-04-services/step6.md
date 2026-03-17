# Шаг 6: Endpoints — что реально за Service

`Endpoints` — объект который K8s создаёт автоматически и хранит актуальные IP:Port всех подов попавших под `selector`.

## Смотрим Endpoints

```bash
kubectl get endpoints
```{{execute}}

```bash
kubectl describe endpoints demo-svc
```{{execute}}

## Endpoints обновляются динамически

```bash
# Масштабируем — Endpoints сразу обновятся
kubectl scale deployment demo-app --replicas=5
sleep 3
kubectl get endpoints demo-svc
```{{execute}}

```bash
kubectl scale deployment demo-app --replicas=2
sleep 3
kubectl get endpoints demo-svc
```{{execute}}

## Service без selector — ручные Endpoints

Иногда нужно создать Service для **внешнего ресурса** (БД вне кластера, другой кластер):

```bash
cat > manual-endpoints.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  # Нет selector — K8s не ищет поды автоматически
  ports:
  - port: 5432
    targetPort: 5432
---
apiVersion: v1
kind: Endpoints
metadata:
  name: external-db     # Имя должно совпадать с именем Service
subsets:
- addresses:
  - ip: 10.0.0.100      # IP внешней БД
  - ip: 10.0.0.101      # Второй узел БД
  ports:
  - port: 5432
EOF
kubectl apply -f manual-endpoints.yaml
```{{execute}}

```bash
kubectl describe service external-db
kubectl get endpoints external-db
```{{execute}}

```bash
# Теперь из любого пода можно обращаться к внешней БД по имени:
# postgresql://external-db:5432/mydb
kubectl delete -f manual-endpoints.yaml
```{{execute}}

## EndpointSlice — замена Endpoints в современном K8s

```bash
kubectl get endpointslices | head -10
```{{execute}}

`EndpointSlice` масштабируется лучше при тысячах подов — делит Endpoints на части по 100 записей.
