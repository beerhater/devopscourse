# Шаг 2: Control Plane

Компоненты Control Plane сами работают как поды в пространстве `kube-system`:

```bash
kubectl get pods -n kube-system
```{{execute}}

- **kube-apiserver** — единственная точка входа. Всё общается только с ним.
- **etcd** — key-value база данных, хранит всё состояние кластера.
- **kube-scheduler** — видит новый Pod без узла → выбирает подходящий по ресурсам.
- **kube-controller-manager** — бесконечный цикл сверки: *должно быть 3 пода, работает 2 → запустить ещё один*.

```bash
kubectl get pods -n kube-system | grep kube-apiserver
```{{execute}}
