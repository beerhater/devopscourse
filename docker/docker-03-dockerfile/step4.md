# Шаг 4: Инструкции CMD и ENTRYPOINT

## CMD — команда по умолчанию

`CMD` задаёт команду, которая выполняется при запуске контейнера. Её **можно переопределить** при `docker run`:

```
CMD ["executable", "arg1", "arg2"]   # exec-форма (рекомендуется)
CMD command arg1 arg2                 # shell-форма
```

## Задание 1: Демонстрация CMD

```bash
cd /opt/myapp
cat > Dockerfile << 'DOCKERFILE'
FROM alpine:3.18
CMD ["echo", "Это команда по умолчанию"]
DOCKERFILE
```{{execute}}

```bash
docker build -t cmd-demo .
```{{execute}}

Запуск с командой по умолчанию:
```bash
docker run --rm cmd-demo
```{{execute}}

Переопределение CMD:
```bash
docker run --rm cmd-demo echo "Это другая команда"
```{{execute}}

## ENTRYPOINT — фиксированная точка входа

`ENTRYPOINT` задаёт команду, которую **нельзя переопределить** обычным способом. Аргументы `docker run` добавляются к ней:

```bash
cat > Dockerfile << 'DOCKERFILE'
FROM alpine:3.18
ENTRYPOINT ["echo", "Привет,"]
CMD ["мир"]
DOCKERFILE
```{{execute}}

```bash
docker build -t entrypoint-demo .
docker run --rm entrypoint-demo
```{{execute}}

```bash
docker run --rm entrypoint-demo Docker!
```{{execute}}

## CMD + ENTRYPOINT вместе

`ENTRYPOINT` — фиксированная программа, `CMD` — аргументы по умолчанию к ней. Это классический паттерн для утилит.
