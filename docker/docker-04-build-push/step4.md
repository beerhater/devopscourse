# Шаг 4: Многоэтапная сборка (multi-stage build)

**Проблема:** образы для сборки содержат компиляторы, инструменты сборки — всё это не нужно в продакшен-образе и раздувает его размер.

**Решение:** multi-stage build — несколько `FROM` в одном Dockerfile. Финальный образ копирует только нужные артефакты из предыдущих этапов.

## Задание: собери Go-приложение

```bash
mkdir -p /opt/multistage && cd /opt/multistage
```{{execute}}

```bash
cat > main.go << 'GO'
package main

import "fmt"

func main() {
    fmt.Println("Hello from a tiny Docker image!")
}
GO
```{{execute}}

```bash
cat > Dockerfile << 'DOCKERFILE'
# Этап 1: сборка (большой образ с Go-компилятором)
FROM golang:1.21-alpine AS builder

WORKDIR /build
COPY main.go .
RUN go build -o app main.go

# Этап 2: финальный образ (минимальный)
FROM alpine:3.18

WORKDIR /app
# Копируем только скомпилированный бинарник из этапа builder
COPY --from=builder /build/app .

CMD ["./app"]
DOCKERFILE
```{{execute}}

```bash
docker build -t multistage-demo .
```{{execute}}

```bash
docker run --rm multistage-demo
```{{execute}}

Сравните размеры:
```bash
docker images golang:1.21-alpine
docker images multistage-demo
```{{execute}}

Разница колоссальная: ~300 МБ vs ~10 МБ!
