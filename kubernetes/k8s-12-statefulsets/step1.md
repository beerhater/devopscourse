# Шаг 1: Поднимаем headless service и StatefulSet

Создайте headless service и `StatefulSet` на 2 реплики.

```bash
cat > /root/stateful-demo.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: app-headless
spec:
  clusterIP: None
  selector:
    app: app-headless
  ports:
    - port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: app-stateful
spec:
  serviceName: app-headless
  replicas: 2
  selector:
    matchLabels:
      app: app-headless
  template:
    metadata:
      labels:
        app: app-headless
    spec:
      containers:
        - name: web
          image: nginx:1.27-alpine
          ports:
            - containerPort: 80
EOF

kubectl apply -f /root/stateful-demo.yaml
kubectl rollout status statefulset/app-stateful --timeout=120s
kubectl get pods -l app=app-headless -o name | sort > /root/stateful_pods.txt
kubectl get svc app-headless -o jsonpath='{.spec.clusterIP}' > /root/stateful_service_type.txt

cat /root/stateful_pods.txt
cat /root/stateful_service_type.txt
```{{execute}}

Обратите внимание на имена pod вроде `app-stateful-0` и `app-stateful-1`.
Именно это даёт предсказуемость для stateful-систем.
