# Шаг 7: Multi-port и sessionAffinity

Реальные приложения часто слушают несколько портов. Также иногда нужно чтобы один клиент всегда попадал на один под.

## Multi-port Service

```bash
# Deployment с nginx который слушает 80 и добавим sidecar на 8080
cat > multiport-deploy.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multiport-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: multiport-app
  template:
    metadata:
      labels:
        app: multiport-app
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
      - name: metrics
        image: nginx:alpine
        command: ["nginx", "-g", "daemon off;", "-p", "/tmp"]
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: nginx-conf
          mountPath: /tmp/conf
      volumes:
      - name: nginx-conf
        emptyDir: {}
EOF
kubectl apply -f multiport-deploy.yaml
kubectl rollout status deployment/multiport-app
```{{execute}}

```bash
cat > multiport-svc.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: multiport-svc
spec:
  selector:
    app: multiport-app
  ports:
  - name: http       # Имя ОБЯЗАТЕЛЬНО при нескольких портах
    port: 80
    targetPort: 80
  - name: metrics
    port: 9090        # Внешний порт может отличаться от targetPort
    targetPort: 8080
EOF
kubectl apply -f multiport-svc.yaml
kubectl describe service multiport-svc
```{{execute}}

## SessionAffinity — липкие сессии

```bash
cat > sticky-svc.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: sticky-svc
spec:
  selector:
    app: demo-app
  ports:
  - port: 80
    targetPort: 80
  sessionAffinity: ClientIP       # Клиент всегда попадает на тот же под
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 3600         # Сессия живёт 1 час
EOF
kubectl apply -f sticky-svc.yaml
kubectl describe service sticky-svc | grep -A3 "Session"
```{{execute}}

```bash
# Проверяем: несколько запросов должны попасть на ОДИН под
for i in {1..5}; do
  kubectl run curl-test-$i --image=curlimages/curl --rm --restart=Never     --overrides='{"spec":{"nodeName":"'$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')'"}}'     -it -- curl -s http://sticky-svc/ | grep -o "Server.*" | head -1 || true
done 2>/dev/null; echo "Done"
```{{execute}}

```bash
kubectl delete deployment multiport-app
kubectl delete service multiport-svc sticky-svc
```{{execute}}
