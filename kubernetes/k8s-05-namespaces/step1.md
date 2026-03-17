# Шаг 1: Системные namespace — что уже есть в кластере

```bash
kubectl get namespaces
```{{execute}}

Что значит каждый:

| Namespace | Назначение |
|-----------|-----------|
| `default` | Всё что создаётся без `-n` |
| `kube-system` | Системные компоненты K8s |
| `kube-public` | Публичные данные кластера |
| `kube-node-lease` | Heartbeat нод |

```bash
# Что живёт в kube-system
kubectl get pods -n kube-system
```{{execute}}

```bash
# CoreDNS, kube-proxy, etcd, api-server — всё системное изолировано
kubectl get deployments -n kube-system
```{{execute}}

```bash
# В kube-public — один объект
kubectl get configmaps -n kube-public
kubectl get configmap cluster-info -n kube-public -o yaml
```{{execute}}

```bash
# Посмотрим на текущий контекст
kubectl config current-context
```{{execute}}

```bash
kubectl config get-contexts
```{{execute}}

`NAMESPACE` в таблице контекстов — это namespace по умолчанию для данного контекста. Пустое значение означает `default`.
