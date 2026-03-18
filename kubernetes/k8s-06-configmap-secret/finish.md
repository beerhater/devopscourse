# Модуль завершён! 🎉

## Что изучили

- **ConfigMap** — несекретные настройки: литералы, файлы, директории, YAML
- **Secret** — пароли и токены: Opaque, TLS, dockerconfigjson, `stringData`
- **`env` + `valueFrom`** — отдельные переменные из CM/Secret
- **`envFrom`** — все ключи CM/Secret сразу как переменные
- **Volume-монтирование** — ключи как файлы, права `defaultMode`
- **Автообновление** — volume обновляется автоматически, env — нет
- **`immutable: true`** — защита от изменений, оптимизация кластера
- **`imagePullSecrets`** — credentials для приватного registry
- **Паттерн config-hash** — принудительный рестарт при смене конфига

## Шпаргалка

```bash
# ConfigMap
kubectl create configmap NAME --from-literal=KEY=VAL
kubectl create configmap NAME --from-file=file.conf
kubectl create configmap NAME --from-file=dir/

# Secret
kubectl create secret generic NAME --from-literal=KEY=VAL
kubectl create secret tls NAME --cert=tls.crt --key=tls.key
kubectl create secret docker-registry NAME --docker-server=... 

# Чтение секрета
kubectl get secret NAME -o jsonpath='{.data.KEY}' | base64 -d

# Рестарт при смене конфига
kubectl rollout restart deployment/NAME
```

## Следующий модуль

**Ingress** — умный HTTP/HTTPS роутинг по доменам и путям через один LoadBalancer.
