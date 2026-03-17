# Шаг 2: kubectl describe — диагностика

```bash
kubectl describe pod my-nginx
```{{execute}}

Ключевые секции:

- **Node:** — на каком узле работает
- **IP:** — внутренний IP (доступен только внутри кластера)
- **Containers:** — образ, статус, порты
- **Conditions:** — этапы готовности (PodScheduled → Initialized → ContainersReady → Ready)
- **Events:** — хронология. **Первое место для диагностики проблем.**

```bash
kubectl describe pod my-nginx | grep -A 20 "Events:"
```{{execute}}
