# Namespace — изоляция ресурсов в кластере

По умолчанию все ресурсы создаются в `default`. В реальных кластерах один K8s обслуживает несколько команд и окружений — для этого и нужны **Namespace**.

## Зачем Namespace

- **Изоляция**: команда backend не видит ресурсы frontend
- **Окружения**: `dev`, `staging`, `production` в одном кластере
- **Лимиты**: ограничить CPU/RAM на namespace через `ResourceQuota`
- **Права**: давать доступ только к своему namespace через RBAC

## Что изучим

- Системные namespace и зачем они нужны
- Создание namespace и работа с `-n` флагом
- `kubectl config set-context` — переключение контекста
- Изоляция: что видно, что нет
- DNS между namespace
- `ResourceQuota` и `LimitRange`
- `kubens` — быстрое переключение namespace

> Смотрим текущие namespace: `kubectl get namespaces`{{execute}}
