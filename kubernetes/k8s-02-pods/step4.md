# Шаг 4: Pod через YAML-манифест

`kubectl run` — для тестов. В работе объекты описываются в **YAML-манифестах**.

```bash
cat > my-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  labels:
    app: web
    version: v1
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
    ports:
    - containerPort: 80
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
      limits:
        memory: "64Mi"
        cpu: "100m"
EOF
kubectl apply -f my-pod.yaml
```{{execute}}

```bash
kubectl get pods -o wide
```{{execute}}

## Анатомия манифеста

| Поле | Описание |
|------|----------|
| `apiVersion` | Версия API (для Pod — `v1`) |
| `kind` | Тип объекта |
| `metadata.labels` | Метки для поиска и группировки |
| `resources.requests` | Минимум (для Scheduler) |
| `resources.limits` | Максимум (жёсткий потолок) |

```bash
kubectl describe pod web-pod | grep -E "Image:|Node:|IP:|Limits:|Requests:"
```{{execute}}
