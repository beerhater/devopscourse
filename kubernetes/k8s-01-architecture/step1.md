# Шаг 1: Общая схема кластера

Кластер K8s делится на две части: **Control Plane** (принимает решения) и **Worker Nodes** (выполняет работу).

```text
            kubectl (вы)
                 |
                 v  REST API
   +----------------------------+
   |       CONTROL PLANE        |
   |                            |
   |  [ API Server ] -- [etcd]  |
   |         |                  |
   |  [Scheduler]               |
   |  [Controller Manager]      |
   +------------+---------------+
                |
   +------------v---------------+
   |        WORKER NODE         |
   |                            |
   |  kubelet --> containerd    |
   |               |            |
   |          [Pod][Pod][Pod]   |
   |                            |
   |  kube-proxy (сеть/iptables)|
   +----------------------------+
```

```bash
kubectl get nodes -o wide
```{{execute}}

**Node** — физический или виртуальный сервер. **Pod** — минимальная единица K8s, обёртка над контейнером.
