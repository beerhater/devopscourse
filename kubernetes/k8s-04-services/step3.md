# Шаг 3: kube-dns — обращение по имени

Kubernetes автоматически регистрирует каждый Service в DNS. Это значит что внутри кластера можно обращаться по имени без знания IP.

## DNS-имена Service

Формат: `<service>.<namespace>.svc.cluster.local`

```bash
# Смотрим как устроен DNS кластера
kubectl get pods -n kube-system | grep dns
```{{execute}}

```bash
# Делаем DNS-резолюцию изнутри пода
kubectl run dns-test --image=busybox --rm -it --restart=Never   -- nslookup demo-svc
```{{execute}}

```bash
# Из другого namespace нужно полное имя
kubectl create namespace staging
kubectl run dns-test2 --image=busybox --rm -it --restart=Never -n staging   -- nslookup demo-svc.default.svc.cluster.local
```{{execute}}

## Переменные окружения (legacy)

K8s также инжектирует переменные окружения в каждый под:

```bash
kubectl run env-test --image=busybox --rm -it --restart=Never   -- sh -c 'env | grep DEMO_SVC'
```{{execute}}

Переменные вида `DEMO_SVC_SERVICE_HOST` и `DEMO_SVC_SERVICE_PORT` — старый способ, предпочтителен DNS.

## Диапазон ClusterIP

```bash
# Узнаём диапазон ClusterIP кластера
kubectl cluster-info dump | grep -m1 "service-cluster-ip-range" ||   kubectl describe configmap kubeadm-config -n kube-system 2>/dev/null | grep serviceSubnet ||   echo "Range: обычно 10.96.0.0/12 в kubeadm-кластерах"
```{{execute}}

```bash
kubectl delete namespace staging
```{{execute}}
