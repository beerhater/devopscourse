# Шаг 5: Жизненный цикл Пода

Как работают все компоненты вместе? Давайте создадим один Под и посмотрим на последовательность событий под капотом.

1. Создаём Под:
```bash
kubectl run my-nginx --image=nginx
```{{execute}}

Что происходит внутри (за доли секунды):
1. **kubectl** шлёт POST-запрос в **API Server**.
2. **API Server** валидирует запрос и пишет в **etcd**: *"Пользователь хочет под my-nginx"*. (Состояние: Pending).
3. **Scheduler** замечает (спрашивая API-сервер), что в базе появился Под без назначенного узла. Он выбирает узел `node01` и сообщает об этом **API Server**.
4. **API Server** обновляет запись в **etcd**: *"Под my-nginx привязан к node01"*.
5. **Kubelet** на узле `node01` периодически опрашивает API-сервер и видит: "О, для меня есть задача!". Он даёт команду **containerd**: *"Скачай образ nginx и запусти контейнер"*.
6. **Kubelet** отправляет статус в **API Server**: *"Под запущен"*. (Состояние: Running).

Давайте посмотрим на реальные логи событий кластера для нашего пода:
```bash
kubectl get events --field-selector involvedObject.name=my-nginx --sort-by='.metadata.creationTimestamp'
```{{execute}}

Вы чётко увидите шаги:
- `Scheduled` (сработал scheduler)
- `Pulling`, `Pulled`, `Created`, `Started` (сработал kubelet)
