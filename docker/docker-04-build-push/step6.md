# Шаг 6: Публикация — docker push

`docker push` загружает образ в реестр. Docker отправляет только **новые слои** — те, которых ещё нет в реестре, что экономит трафик.

## Синтаксис

```
docker push [REGISTRY/]USERNAME/IMAGE:TAG
```

## Практика: локальный реестр

Запустим собственный реестр в контейнере — это полная альтернатива Docker Hub для локальной работы:

```bash
docker run -d -p 5000:5000 --name local-registry registry:2
```{{execute}}

Тегируйте образ для локального реестра:
```bash
docker tag buildapp:1.0 localhost:5000/buildapp:1.0
docker tag buildapp:latest localhost:5000/buildapp:latest
```{{execute}}

Запушьте в локальный реестр:
```bash
docker push localhost:5000/buildapp:1.0
docker push localhost:5000/buildapp:latest
```{{execute}}

Посмотрите, что лежит в реестре:
```bash
curl http://localhost:5000/v2/_catalog
```{{execute}}

Посмотрите теги конкретного образа:
```bash
curl http://localhost:5000/v2/buildapp/tags/list
```{{execute}}

Удалите локальный образ и скачайте обратно из реестра:
```bash
docker rmi localhost:5000/buildapp:1.0
docker pull localhost:5000/buildapp:1.0
docker run --rm localhost:5000/buildapp:1.0
```{{execute}}
