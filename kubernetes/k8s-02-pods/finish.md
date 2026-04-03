# Модуль завершён! 🎉

## Шпаргалка

```bash
kubectl run NAME --image=IMAGE          # создать под
kubectl get pods -o wide                # список подов
kubectl describe pod NAME               # полная диагностика
kubectl logs NAME [-c CONTAINER]        # логи
kubectl logs NAME --previous            # логи упавшего
kubectl exec -it NAME -- /bin/sh        # шелл внутри
kubectl apply -f manifest.yaml          # создать из файла
kubectl delete pod NAME                 # удалить
kubectl get pods -l key=value           # фильтр по labels
```

## Статусы для запоминания

| Статус | Причина |
|--------|---------|
| `CrashLoopBackOff` | Контейнер падает при запуске |
| `ImagePullBackOff` | Неверное имя образа / нет доступа |
| `Pending` | Нет ресурсов или узлов |
| `OOMKilled` | Превышен memory limit |

## Опциональная очистка

```bash
kubectl delete pod final-app sidecar-demo init-demo my-nginx web-pod 2>/dev/null; true
```

Следующий модуль: **Deployment** — самовосстановление и rolling updates.
