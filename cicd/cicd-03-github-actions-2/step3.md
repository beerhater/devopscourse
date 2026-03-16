# Шаг 3: Публикация образа в Docker Hub

## Как авторизация работает в CI/CD

Никогда не пишите логин/пароль прямо в workflow-файл — он хранится в Git и виден всем! В GitHub Actions используются **Secrets** — зашифрованные переменные, доступные только во время выполнения workflow.

Настройка секретов в GitHub:
```
Репозиторий → Settings → Secrets and variables → Actions → New repository secret
```

Нужны два секрета:
- `DOCKERHUB_USERNAME` — ваш логин на Docker Hub
- `DOCKERHUB_TOKEN` — Access Token (не пароль!) из hub.docker.com → Account Settings → Security

## Workflow с push в Docker Hub

```bash
cd /opt/docker-actions-demo
```{{execute}}

```bash
cat > .github/workflows/docker-build-push.yml << 'WORKFLOW'
name: Build and Push to Docker Hub

on:
  push:
    branches: [main]        # Пушить в Docker Hub только из main
  pull_request:
    branches: [main]        # Только собирать (без пуша) для PR

jobs:
  test:
    name: "Tests"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: python3 tests.py

  build-and-push:
    name: "Build & Push"
    runs-on: ubuntu-latest
    needs: test

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      # Set up Buildx — нужен для кэширования и multi-platform
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      # Авторизация в Docker Hub
      # github.event_name != 'pull_request' — не логинимся для PR
      # (для PR у нас всё равно push: false, но это хорошая практика)
      - name: Login to Docker Hub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v3
        with:
          # Обращаемся к секретам через ${{ secrets.ИМЯ }}
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      # Автоматическая генерация тегов
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          # Формат: dockerhub_username/repo_name
          images: ${{ secrets.DOCKERHUB_USERNAME }}/docker-actions-demo
          tags: |
            # Для ветки main → тег "latest"
            type=raw,value=latest,enable=${{ github.ref_name == 'main' }}
            # Короткий SHA коммита → sha-abc1234
            type=sha,prefix=sha-
            # Если это git-тег v1.2.3 → тег "1.2.3"
            type=semver,pattern={{version}}
            # Имя ветки → branch-main
            type=ref,event=branch

      # Сборка и (если не PR) — пуш
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          # push: true только если это не PR
          # Для PR — только собираем, не пушим
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          build-args: |
            APP_VERSION=${{ github.ref_name }}
            BUILD_SHA=${{ github.sha }}

      # Показываем digest (уникальный ID) собранного образа
      - name: Image digest
        run: echo "Image digest: ${{ steps.build.outputs.digest }}"
WORKFLOW
```{{execute}}

## Почему Access Token, а не пароль?

```bash
cat > /opt/docker-actions-demo/security-notes.txt << 'EOF'
БЕЗОПАСНОСТЬ: почему нельзя использовать пароль
===============================================

1. Принцип минимальных прав (Least Privilege)
   Access Token можно настроить только на Read/Write для образов.
   Пароль даёт полный доступ к аккаунту.

2. Отзыв без смены пароля
   Если токен утёк — удалите его. Пароль менять не нужно.
   Скомпрометированный пароль = полная смена всех секретов везде.

3. Аудит
   В Docker Hub видно какой токен использовался и когда.

4. Разные токены для разных проектов
   Один репозиторий — один токен. Утечка одного не даст доступ ко всем.

КАК СОЗДАТЬ ACCESS TOKEN В DOCKER HUB:
  hub.docker.com → Account Settings → Security → New Access Token
  Права: Read & Write (для push)
        Read-only (для pull-only сценариев)
EOF
cat /opt/docker-actions-demo/security-notes.txt
```{{execute}}

## Локальная симуляция: push в локальный registry

Так как у нас нет реального Docker Hub, создадим **локальный registry** и проверим что push работает:

```bash
# Запускаем локальный Docker registry на порту 5000
docker run -d --name local-registry -p 5000:5000 registry:2
echo "Локальный registry запущен"
```{{execute}}

```bash
# Собираем образ и пушим в локальный registry
docker build   --build-arg APP_VERSION=1.0.0   --build-arg BUILD_SHA=abc1234   -t localhost:5000/docker-actions-demo:latest   -t localhost:5000/docker-actions-demo:sha-abc1234   /opt/docker-actions-demo/
```{{execute}}

```bash
docker push localhost:5000/docker-actions-demo:latest
docker push localhost:5000/docker-actions-demo:sha-abc1234
```{{execute}}

```bash
# Проверяем что образ есть в registry через API
curl -s http://localhost:5000/v2/docker-actions-demo/tags/list | python3 -m json.tool
```{{execute}}

```bash
# Симулируем деплой: скачиваем образ из нашего registry
docker rmi localhost:5000/docker-actions-demo:sha-abc1234 2>/dev/null || true
docker pull localhost:5000/docker-actions-demo:sha-abc1234
docker run --rm localhost:5000/docker-actions-demo:sha-abc1234 python3 -c "import app; print('OK: app imported from registry')"
```{{execute}}
