# Модуль завершён! 🎉

## Что изучили

- **Проблема**: IP пода меняется — нужен стабильный адрес
- **ClusterIP** — виртуальный IP внутри кластера, связь между микросервисами
- **NodePort** — открывает порт на каждом узле, для dev/staging
- **LoadBalancer** — облачный балансировщик, для продакшн-трафика
- **ExternalName** — DNS CNAME на внешний хост
- **Headless** — без ClusterIP, DNS возвращает IP всех подов (StatefulSet)
- **Endpoints / EndpointSlice** — динамический список IP подов за Service
- **kube-dns** — DNS-имена вида `svc.namespace.svc.cluster.local`
- **sessionAffinity** — липкие сессии по ClientIP
- **Multi-port** — несколько портов в одном Service

## Шпаргалка

```bash
# Создание
kubectl expose deployment NAME --port=80 --target-port=8080
kubectl expose deployment NAME --type=NodePort --port=80
kubectl apply -f service.yaml

# Просмотр
kubectl get services
kubectl get endpoints SVC_NAME
kubectl describe service SVC_NAME

# DNS внутри кластера
# <service>.<namespace>.svc.cluster.local
curl http://my-svc.default.svc.cluster.local:80/

# Доступ через NodePort
curl http://<node-ip>:<node-port>/
```

## Следующий модуль

**Ingress** — умный HTTP/HTTPS роутинг: один IP, много сервисов по доменам и путям.
