# Шаг 3: Логи и exec

```bash
kubectl logs my-nginx
```{{execute}}

```bash
# Follow logs в реальном времени (как tail -f)
kubectl logs my-nginx -f &
sleep 3 && kill %1 2>/dev/null; true
```{{execute}}

## Exec — команда внутри пода

```bash
kubectl exec my-nginx -- nginx -v
```{{execute}}

```bash
# Интерактивный шелл
kubectl exec -it my-nginx -- /bin/bash
```{{execute}}

Внутри пода:
```bash
hostname
cat /etc/nginx/nginx.conf | head -5
exit
```{{execute}}

## Обращение к поду по IP изнутри кластера

```bash
POD_IP=$(kubectl get pod my-nginx -o jsonpath='{.status.podIP}')
echo "Pod IP: $POD_IP"
kubectl run curl-test --image=curlimages/curl --rm -it --restart=Never -- curl -s http://$POD_IP | head -5
```{{execute}}
