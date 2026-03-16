## Лучшие практики — меньше слоёв, меньше размер

Каждый `RUN` = новый слой. Чем меньше слоёв — тем легче образ и быстрее сборка.

Сравнение:
```
# Плохо: 3 слоя
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y wget

# Хорошо: 1 слой
RUN apt-get update && \
    apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*
```

---

1. Создайте оптимизированный Dockerfile:
`nano /root/myapp/Dockerfile.optimized`

2. Введите:
```
FROM alpine:3.18

ENV APP_VERSION=1.0.0

RUN apk add --no-cache bash curl

WORKDIR /app
COPY app.sh /app/app.sh
RUN chmod +x /app/app.sh

CMD ["/app/app.sh"]
```

Alpine Linux вместо Ubuntu сразу уменьшает базовый размер с ~80MB до ~5MB!

3. Посмотрите итоговый Dockerfile:
`cat /root/myapp/Dockerfile`
