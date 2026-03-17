# Шаг 4: API Server — центр всего

**Правило K8s:** никто не общается ни с кем напрямую. Всё идёт только через API Server по REST/HTTP.

Посмотрим на реальные HTTP-запросы под капотом `kubectl get nodes`:

```bash
kubectl get nodes -v=8 2>&1 | grep -E "GET|Response Status"
```{{execute}}

Видите строку `GET https://.../api/v1/nodes`? kubectl — просто REST-клиент.

Вызовем API напрямую через proxy:
```bash
kubectl proxy --port=8001 &
sleep 2
curl -s http://localhost:8001/api/v1/nodes | python3 -m json.tool | head -15
kill %1 2>/dev/null; true
```{{execute}}
