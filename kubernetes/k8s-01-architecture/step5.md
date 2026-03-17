# Шаг 5: Жизненный цикл Пода

Создадим под и проследим как все компоненты работают вместе:

```bash
kubectl run demo --image=nginx
```{{execute}}

Что произошло:
1. **kubectl** → POST в **API Server**
2. **API Server** → пишет в **etcd**: *"нужен pod demo"* (Pending)
3. **Scheduler** → видит под без узла → выбирает node01 → сообщает API Server
4. **kubelet** на node01 → замечает задание → говорит **containerd**: *"скачай nginx, запусти"*
5. **kubelet** → отчитывается: *"pod Running"*

Посмотрим хронологию:
```bash
kubectl get events --field-selector involvedObject.name=demo --sort-by='.metadata.creationTimestamp'
```{{execute}}

Видите шаги: `Scheduled` (Scheduler), `Pulling`, `Pulled`, `Created`, `Started` (kubelet).

```bash
kubectl get pod demo
```{{execute}}
