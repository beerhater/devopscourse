## FROM и RUN — база и зависимости

`FROM` — первая инструкция любого Dockerfile.
`RUN` — выполняет shell-команду при **сборке** образа.

---

1. Создайте рабочую папку:
`mkdir -p /root/myapp && cd /root/myapp`

2. Создайте Dockerfile:
`nano Dockerfile`

3. Введите:
```
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*
```

Обратите внимание:
- Несколько команд объединены через `&&` в одном `RUN` — это один слой вместо трёх
- `rm -rf /var/lib/apt/lists/*` — очищаем кэш apt чтобы образ был меньше

Сохраните файл.
