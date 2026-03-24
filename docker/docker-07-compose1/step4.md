# Шаг 4: Управление стеком — ps, logs, exec

## Запустите стек

```bash
cd /opt/compose-intro && docker compose up -d
```{{execute}}

## docker compose ps

```bash
docker compose ps
```{{execute}}

## docker compose logs

Все сервисы:
```bash
docker compose logs
```{{execute}}

Конкретный сервис:
```bash
docker compose logs web
```{{execute}}

Следить в реальном времени (Ctrl+C для выхода):
```bash
docker compose logs -f app
```{{execute}}

## docker compose exec

```bash
docker compose exec web nginx -v
```{{execute}}

```bash
docker compose exec web ls /etc/nginx/
```{{execute}}

## docker compose top

```bash
docker compose top
```{{execute}}

## Управление отдельными сервисами

```bash
docker compose stop web
docker compose ps
```{{execute}}

```bash
docker compose start web
docker compose ps
```{{execute}}

```bash
docker compose restart app
```{{execute}}
