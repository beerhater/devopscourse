# Поздравляем! 🎉

Вы завершили модуль **«GitHub Actions: Часть 2»**!

## Что вы освоили

- **Docker build в Actions**: `docker/setup-buildx-action`, `docker/build-push-action`
- **Умные теги**: `docker/metadata-action` — latest, SHA, semver автоматически
- **Docker Hub push**: авторизация через `docker/login-action` и секреты
- **Локальный registry**: симуляция push без Docker Hub
- **Кэширование слоёв**: `cache-from/cache-to: type=gha`, оптимизация Dockerfile
- **Matrix builds**: параллельный запуск на нескольких версиях Python и OS
- **Полный pipeline**: lint → test (matrix) → build+push → deploy
- **Job outputs**: передача данных между jobs через `outputs:`

## Ключевые Actions для Docker

| Action | Что делает |
|--------|-----------|
| `docker/setup-buildx-action@v3` | Инициализирует Buildx (нужен для кэша) |
| `docker/login-action@v3` | Авторизация в registry |
| `docker/metadata-action@v5` | Генерирует теги из git-метаданных |
| `docker/build-push-action@v5` | Сборка и push образа |

## Минимальный рабочий Docker CI/CD

```yaml
- uses: docker/setup-buildx-action@v3
- uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
- uses: docker/build-push-action@v5
  with:
    push: true
    tags: username/app:latest
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

## Что дальше

| Модуль | Статус |
|--------|--------|
| CI/CD 01: Введение, bash-пайплайн | Done |
| CI/CD 02: GitHub Actions ч.1 | Done |
| CI/CD 03: GitHub Actions ч.2 + Docker | Done |
| CI/CD 04: GitLab CI ч.1 | Next |
| CI/CD 05: GitLab CI ч.2 | Soon |
| CI/CD 06: Автотесты | Soon |
| CI/CD 07: Стратегии деплоя | Soon |
