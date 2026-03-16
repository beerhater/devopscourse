# Шаг 4: Кэширование Docker-слоёв

## Зачем кэшировать?

Без кэша каждый запуск пайплайна скачивает базовый образ и переустанавливает все зависимости с нуля. Для Python-проекта с FastAPI это может занимать **3-5 минут** только на установку пакетов.

С кэшем — если `requirements.txt` не изменился, `pip install` пропускается: **30 секунд вместо 3 минут**.

## Как работает кэш Docker-слоёв

```bash
cat > /opt/docker-actions-demo/cache-explained.txt << 'EOF'
КАК РАБОТАЕТ КЭШИРОВАНИЕ СЛОЁВ DOCKER
======================================

Dockerfile:
  FROM python:3.11-alpine         # Слой 1: базовый образ
  COPY requirements.txt .         # Слой 2: файл зависимостей
  RUN pip install -r req...       # Слой 3: установка пакетов  <-- ДОЛГО
  COPY app.py .                   # Слой 4: код приложения
  CMD ["python3", "app.py"]       # Слой 5: команда запуска

Первый запуск: всё скачивается и устанавливается — 3 минуты

Второй запуск (изменился только app.py):
  Слой 1: FROM python         ← из кэша (не изменился)
  Слой 2: COPY requirements   ← из кэша (не изменился)
  Слой 3: RUN pip install     ← из кэша (requirements.txt тот же!)
  Слой 4: COPY app.py         ← ПЕРЕСОБИРАЕТСЯ (файл изменился)
  Слой 5: CMD                 ← ПЕРЕСОБИРАЕТСЯ (зависит от слоя 4)
  Итого: 10 секунд вместо 3 минут!

ВАЖНО: Порядок инструкций в Dockerfile влияет на эффективность кэша!
  ПЛОХО:  COPY . .  → потом pip install  (кэш сбрасывается при любом изменении кода)
  ХОРОШО: COPY requirements.txt . → pip install → COPY . .
EOF
cat /opt/docker-actions-demo/cache-explained.txt
```{{execute}}

## Оптимизированный Dockerfile

```bash
cd /opt/docker-actions-demo
```{{execute}}

```bash
cat > Dockerfile.optimized << 'DFILE'
FROM python:3.11-alpine

ARG APP_VERSION=dev
ARG BUILD_SHA=unknown
ENV APP_VERSION=$APP_VERSION
ENV BUILD_SHA=$BUILD_SHA

WORKDIR /app

# ПРАВИЛО: сначала то что меняется редко → потом то что меняется часто
# requirements.txt меняется редко → этот слой будет в кэше почти всегда
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Код меняется часто → пересобирается, но pip install уже в кэше
COPY app.py .
COPY tests.py .

RUN python3 tests.py

EXPOSE 8080
CMD ["python3", "app.py"]
DFILE
```{{execute}}

## Workflow с кэшированием

```bash
cat > .github/workflows/docker-with-cache.yml << 'WORKFLOW'
name: Docker Build with Cache

on: push

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: local/cached-app
          tags: type=sha,prefix=sha-

      # Сборка С кэшированием
      - name: Build with cache
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./Dockerfile.optimized
          push: false
          load: true
          tags: ${{ steps.meta.outputs.tags }}
          build-args: |
            APP_VERSION=1.0.0
            BUILD_SHA=${{ github.sha }}

          # Кэш берём из GitHub Actions Cache
          # cache-from: откуда брать кэш
          # cache-to: куда сохранять кэш после сборки
          cache-from: type=gha
          cache-to: type=gha,mode=max

          # mode=max — кэшировать все промежуточные слои
          # mode=min — только итоговый слой (меньше места, менее эффективно)

      # Показываем размер собранного образа
      - name: Show image info
        run: |
          echo "=== Информация об образе ==="
          docker images local/cached-app
          echo ""
          echo "=== История слоёв ==="
          docker history local/cached-app:sha-$(echo ${{ github.sha }} | head -c 8) 2>/dev/null || docker images local/cached-app

      - name: Run tests in container
        run: |
          docker run --rm local/cached-app:$(docker images local/cached-app --format "{{.Tag}}" | head -1) python3 tests.py
WORKFLOW
```{{execute}}

## Сравнение времени: с кэшем и без

```bash
# Первая сборка (без кэша) — засечём время
echo "=== Сборка БЕЗ кэша ==="
time docker build --no-cache -t demo-no-cache:test /opt/docker-actions-demo/ 2>&1 | tail -5
```{{execute}}

```bash
# Вторая сборка (с кэшем, ничего не изменилось) — должна быть быстрее
echo "=== Сборка С кэшем (всё закэшировано) ==="
time docker build -t demo-with-cache:test /opt/docker-actions-demo/ 2>&1 | tail -5
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/docker-with-cache.yml')); print('YAML OK')"
```{{execute}}
