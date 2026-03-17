# Шаг 5: Жизненный цикл и статусы

| Статус | Что происходит |
|--------|----------------|
| `Pending` | Принят, но ещё не запущен (планирование, скачивание образа) |
| `Running` | Хотя бы один контейнер запущен |
| `Succeeded` | Все контейнеры завершились (код 0) |
| `Failed` | Контейнер завершился с ошибкой |
| `CrashLoopBackOff` | Постоянно падает, K8s делает паузы |
| `ImagePullBackOff` | Не может скачать образ |

## Демонстрация CrashLoopBackOff

```bash
kubectl run crash-demo --image=busybox -- sh -c "echo 'crash!' && exit 1"
sleep 6 && kubectl get pods crash-demo
```{{execute}}

```bash
kubectl logs crash-demo
```{{execute}}

```bash
kubectl logs crash-demo --previous 2>/dev/null || echo "(предыдущего запуска ещё нет)"
```{{execute}}

```bash
kubectl delete pod crash-demo busybox
```{{execute}}

**Важно:** Pod не самовосстанавливается. Удалишь — исчезнет. Для самовосстановления нужен **Deployment** (следующий модуль).
