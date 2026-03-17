# Шаг 2: ClusterIP — внутренний сервис

`ClusterIP` — тип по умолчанию. Доступен **только внутри кластера**, идеально для связи между микросервисами.

## Создаём ClusterIP через kubectl expose

```bash
kubectl expose deployment demo-app --port=80 --target-port=80 --name=demo-svc
```{{execute}}

```bash
kubectl get service demo-svc
```{{execute}}

Видите поле `CLUSTER-IP`? Этот IP постоянен пока существует Service.

## Как работает selector

```bash
kubectl describe service demo-svc
```{{execute}}

Обратите внимание на `Selector: app=demo-app` и секцию `Endpoints` — там IP всех живых подов.

```bash
# Endpoints автоматически обновляются при изменении подов
kubectl get endpoints demo-svc
```{{execute}}

## Обращаемся к сервису изнутри кластера

```bash
# Запускаем под-клиент и делаем запрос через имя сервиса
kubectl run client --image=curlimages/curl --rm -it --restart=Never   -- curl -s http://demo-svc/
```{{execute}}

```bash
# Обращение по короткому имени работает благодаря kube-dns
kubectl run client2 --image=curlimages/curl --rm -it --restart=Never   -- curl -s http://demo-svc.default.svc.cluster.local/ | head -5
```{{execute}}

## YAML-манифест ClusterIP

```bash
cat > clusterip.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: demo-svc-yaml
spec:
  type: ClusterIP        # По умолчанию, можно не писать
  selector:
    app: demo-app        # Находит поды с этим label
  ports:
  - name: http
    port: 80             # Порт самого Service (ClusterIP:80)
    targetPort: 80       # Порт внутри пода
    protocol: TCP
EOF
kubectl apply -f clusterip.yaml
kubectl get svc demo-svc-yaml
```{{execute}}

```bash
kubectl get endpoints demo-svc-yaml
```{{execute}}

У обоих Service одинаковые Endpoints — оба смотрят на одни поды по `selector`.
