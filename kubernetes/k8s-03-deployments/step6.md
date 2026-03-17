# Шаг 6: Стратегия Recreate и сравнение со RollingUpdate

Кроме `RollingUpdate` есть стратегия `Recreate` — убить все старые поды, затем поднять новые.

## Recreate: когда downtime допустим

```bash
cat > recreate-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: recreate-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: recreate-app
  strategy:
    type: Recreate        # Все старые поды удаляются ПЕРЕД созданием новых
  template:
    metadata:
      labels:
        app: recreate-app
    spec:
      containers:
      - name: app
        image: nginx:1.24-alpine
        ports:
        - containerPort: 80
EOF
kubectl apply -f recreate-deployment.yaml
kubectl rollout status deployment/recreate-app
```{{execute}}

```bash
# Обновляем — увидим downtime
kubectl set image deployment/recreate-app app=nginx:1.25-alpine
kubectl get pods -l app=recreate-app -w
```{{execute}}

Нажмите `Ctrl+C`. Видите? Все старые поды удалились **до** того как новые стартовали — это и есть downtime.

## Сравнение стратегий

| | RollingUpdate | Recreate |
|-|---------------|----------|
| Downtime | Нет | Есть |
| Скорость | Медленнее | Быстрее |
| Ресурсы | Нужны доп. ресурсы на `maxSurge` | Нет |
| Использование | Stateless сервисы (API, фронт) | БД с миграциями, legacy |
| Одновременно 2 версии | Да | Нет |

## Когда Recreate лучше

Recreate нужен когда **нельзя** одновременно работать двум версиям:
- База данных делает несовместимую миграцию схемы
- Приложение захватывает эксклюзивный ресурс (файл, порт)
- Несовместимые изменения API

```bash
kubectl delete deployment recreate-app
```{{execute}}
