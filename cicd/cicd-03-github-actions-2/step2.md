# Шаг 2: Docker build в GitHub Actions

## Создайте Dockerfile

```bash
cd /opt/docker-actions-demo
```{{execute}}

```bash
cat > Dockerfile << 'DFILE'
# Используем официальный минимальный образ Python
FROM python:3.11-alpine

# Метаданные образа
LABEL maintainer="student@devops.local"
LABEL description="Demo app built by GitHub Actions"

# Аргумент для передачи версии при сборке
# В пайплайне: docker build --build-arg APP_VERSION=1.0.0 .
ARG APP_VERSION=dev
ARG BUILD_SHA=unknown

# Записываем версию как переменную окружения в образ
ENV APP_VERSION=$APP_VERSION
ENV BUILD_SHA=$BUILD_SHA
ENV PORT=8080

WORKDIR /app

# Сначала копируем только зависимости — это позволяет кэшировать слой
# Если requirements.txt не изменился — Docker не будет переустанавливать пакеты
COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# Теперь копируем код приложения
COPY app.py .
COPY tests.py .

# Запускаем тесты прямо при сборке образа
# Если тесты упадут — docker build завершится с ошибкой
RUN python3 tests.py

# Открываем порт (документационно — не обязательно)
EXPOSE 8080

# Команда запуска
CMD ["python3", "app.py"]
DFILE
```{{execute}}

```bash
# Проверим что образ собирается
docker build -t docker-actions-demo:test .
```{{execute}}

```bash
# Проверим что контейнер стартует
docker run -d --name test-app -p 8080:8080 docker-actions-demo:test
sleep 2
curl http://localhost:8080
docker stop test-app && docker rm test-app
```{{execute}}

## Workflow: docker build в Actions

```bash
cat > .github/workflows/docker-build.yml << 'WORKFLOW'
name: Docker Build

on: push

jobs:
  # ── Job 1: Тесты ──────────────────────────────────────────────
  test:
    name: "Run Tests"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run tests
        run: python3 tests.py

  # ── Job 2: Docker Build ────────────────────────────────────────
  docker-build:
    name: "Docker Build"
    runs-on: ubuntu-latest
    needs: test   # Запускается только если тесты прошли!

    steps:
      # Шаг 1: Получить код из репозитория
      - name: Checkout code
        uses: actions/checkout@v4

      # Шаг 2: Подготовить Docker Buildx
      # Buildx — расширенный движок сборки Docker
      # Нужен для multi-platform сборок и кэширования
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      # Шаг 3: Сгенерировать метаданные для образа
      # Этот Action автоматически создаёт теги на основе:
      # - ветки: main → latest
      # - git-тега: v1.2.3 → 1.2.3
      # - SHA коммита: abc1234 → sha-abc1234
      - name: Extract metadata
        id: meta   # id нужен чтобы использовать outputs этого шага
        uses: docker/metadata-action@v5
        with:
          images: local/docker-actions-demo   # имя образа
          tags: |
            type=ref,event=branch
            type=sha,prefix=sha-
            type=raw,value=latest,enable=${{ github.ref_name == 'main' }}

      # Шаг 4: Показать что сгенерировал metadata-action
      - name: Show generated tags
        run: |
          echo "Сгенерированные теги:"
          echo "${{ steps.meta.outputs.tags }}"
          echo ""
          echo "Labels:"
          echo "${{ steps.meta.outputs.labels }}"

      # Шаг 5: Собрать Docker-образ
      # push: false — только сборка, без отправки в registry
      - name: Build Docker image
        uses: docker/build-push-action@v5
        with:
          context: .              # Путь к Dockerfile (текущая директория)
          file: ./Dockerfile      # Имя Dockerfile
          push: false             # НЕ пушить (нет credentials)
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          build-args: |
            APP_VERSION=1.0.0
            BUILD_SHA=${{ github.sha }}
          # load: true — загрузить образ в локальный Docker после сборки
          load: true

      # Шаг 6: Проверить что образ собрался
      - name: Test built image
        run: |
          docker images | grep docker-actions-demo
          docker run --rm local/docker-actions-demo:latest python3 tests.py
WORKFLOW
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/docker-build.yml')); print('YAML OK')"
```{{execute}}

## Инициализируем репозиторий и запускаем через act

```bash
git init
git config user.email "student@devops.local"
git config user.name "Student"
git add .
git commit -m "Initial commit: docker demo app"
```{{execute}}

```bash
act push -W .github/workflows/docker-build.yml   --pull=false   -P ubuntu-latest=catthehacker/ubuntu:act-latest 2>&1 | tail -40
```{{execute}}
