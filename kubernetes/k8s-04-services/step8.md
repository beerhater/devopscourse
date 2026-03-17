# Шаг 8: ExternalName и headless Service

Два специальных типа которые используются в реальных архитектурах.

## ExternalName — DNS алиас

`ExternalName` не проксирует трафик, только возвращает CNAME в DNS. Удобно для переключения между внешними сервисами без правки кода.

```bash
cat > external-name.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: prod-database
  namespace: default
spec:
  type: ExternalName
  externalName: db.example.com    # Внешний DNS-адрес
  # Поды обращаются к prod-database:5432
  # K8s DNS вернёт CNAME → db.example.com
  # Чтобы переключиться на новую БД — меняем только externalName
EOF
kubectl apply -f external-name.yaml
kubectl get service prod-database
```{{execute}}

```bash
kubectl describe service prod-database
```{{execute}}

## Headless Service — прямой доступ к подам

Если `clusterIP: None` — Service не получает виртуальный IP. DNS возвращает **IP всех подов напрямую**. Нужно для StatefulSet (базы данных, Kafka, Elasticsearch).

```bash
cat > headless.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: demo-headless
spec:
  clusterIP: None      # Headless — нет виртуального IP
  selector:
    app: demo-app
  ports:
  - port: 80
    targetPort: 80
EOF
kubectl apply -f headless.yaml
kubectl get service demo-headless
```{{execute}}

```bash
# Обычный Service: DNS → один ClusterIP
kubectl run dns1 --image=busybox --rm -it --restart=Never   -- nslookup demo-svc 2>/dev/null | grep -A2 "Name:"
```{{execute}}

```bash
# Headless: DNS → все IP подов напрямую
kubectl run dns2 --image=busybox --rm -it --restart=Never   -- nslookup demo-headless 2>/dev/null | grep "Address:"
```{{execute}}

Видите разницу? У headless несколько A-записей — по одной на каждый под.

```bash
kubectl delete service demo-headless prod-database
kubectl delete -f external-name.yaml 2>/dev/null; true
```{{execute}}
