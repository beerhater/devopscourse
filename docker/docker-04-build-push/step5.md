# Шаг 5: Авторизация — docker login

Для публикации образов в реестр нужно авторизоваться.

## Docker Hub

```
docker login
```

Или сразу с параметрами (для скриптов):
```
docker login -u USERNAME -p PASSWORD
```

## Другие реестры

Docker поддерживает любые реестры — достаточно указать адрес:

```bash
# GitHub Container Registry
docker login ghcr.io

# GitLab Registry
docker login registry.gitlab.com

# Приватный реестр
docker login my-registry.company.com:5000
```

## Где хранятся credentials

```bash
cat ~/.docker/config.json
```{{execute}}

Токены хранятся в `~/.docker/config.json`. В реальных проектах используйте `docker-credential-helpers` или переменные окружения CI/CD вместо хранения паролей в открытом виде.

## Задание: посмотрите конфигурацию Docker

```bash
docker info | grep -A5 "Registry"
```{{execute}}

```bash
docker info | grep "Username" || echo "Не авторизован — это нормально для данного упражнения"
```{{execute}}

> **Примечание:** В этой среде реальная авторизация на Docker Hub недоступна. На следующем шаге мы разберём `docker push` на практическом примере с локальным реестром.
