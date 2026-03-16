# Шаг 6: Пайплайн с Docker

В реальных проектах пайплайн собирает **Docker-образ** и пушит его в registry. Давайте добавим Docker в наш пайплайн — это именно то, что делает GitHub Actions или GitLab CI при сборке контейнеров.

## Создайте Dockerfile

```bash
cd /opt/myapp
```{{execute}}

```bash
cat > Dockerfile << 'DFILE'
FROM python:3.11-alpine

LABEL maintainer="student@devops-course.ru"
LABEL description="Учебное приложение для CI/CD модуля"

WORKDIR /app

# Копируем только нужные файлы
COPY app.py .
COPY tests.py .

# Проверяем что приложение работает при сборке
RUN python3 app.py

# Проверяем что тесты проходят при сборке образа
RUN python3 tests.py

CMD ["python3", "app.py"]
DFILE
```{{execute}}

## Создайте полный Docker-пайплайн

```bash
cat > docker-pipeline.sh << 'PIPELINE'
#!/bin/bash

# ================================================================
# CI/CD пайплайн с Docker
# ================================================================

RED='[0;31m'
GREEN='[0;32m'
YELLOW='[1;33m'
BLUE='[0;34m'
NC='[0m'

# Конфигурация
APP_NAME="myapp"
APP_VERSION="1.0.0"
BUILD_NUMBER="${BUILD_NUMBER:-$(date +%Y%m%d%H%M%S)}"
IMAGE_TAG="${APP_NAME}:${APP_VERSION}-build.${BUILD_NUMBER}"
IMAGE_LATEST="${APP_NAME}:latest"

PIPELINE_START=$(date +%s)
FAILED=0

step() {
    local NAME="$1"
    local CMD="$2"
    echo -e "${YELLOW}▶ $NAME${NC}"
    if eval "$CMD"; then
        echo -e "${GREEN}  ✅ OK${NC}
"
    else
        echo -e "${RED}  ❌ FAILED${NC}"
        FAILED=1
        return 1
    fi
}

echo -e "${BLUE}=== 🐳 Docker CI/CD Pipeline ===${NC}"
echo "Image: $IMAGE_TAG"
echo ""

# ── STAGE: BUILD ──────────────────────────────────────────────
echo -e "${BLUE}━━━ STAGE: BUILD ━━━━━━━━━━━━━━━━━━━━━${NC}"

step "Build Docker image"     "docker build -t '$IMAGE_TAG' -t '$IMAGE_LATEST' . 2>&1" || exit 1

step "Check image was created"     "docker images '$APP_NAME' | grep -q '$APP_VERSION'" || exit 1

# ── STAGE: TEST ───────────────────────────────────────────────
echo -e "${BLUE}━━━ STAGE: TEST ━━━━━━━━━━━━━━━━━━━━━━${NC}"

step "Run tests inside container"     "docker run --rm '$IMAGE_TAG' python3 tests.py" || exit 1

step "Check container starts correctly"     "docker run --rm '$IMAGE_TAG' python3 app.py" || exit 1

# ── STAGE: SECURITY SCAN (упрощённый) ────────────────────────
echo -e "${BLUE}━━━ STAGE: SCAN ━━━━━━━━━━━━━━━━━━━━━━${NC}"

step "Check image size (must be < 200MB)" "
    SIZE_BYTES=\$(docker image inspect '$IMAGE_TAG' --format='{{.Size}}')
    SIZE_MB=\$((SIZE_BYTES / 1024 / 1024))
    echo "Image size: \${SIZE_MB}MB"
    [ \$SIZE_MB -lt 200 ]
" || exit 1

step "Check no root processes by default" "
    USER=\$(docker run --rm '$IMAGE_TAG' whoami)
    echo "Running as: \$USER"
    echo 'Note: running as root is OK for learning, in prod use non-root user'
" || true  # Не блокируем пайплайн, просто информируем

# ── STAGE: PACKAGE ────────────────────────────────────────────
echo -e "${BLUE}━━━ STAGE: PACKAGE ━━━━━━━━━━━━━━━━━━━${NC}"

step "Save image as tar (симуляция push в registry)"     "docker save '$IMAGE_TAG' | gzip > /opt/artifacts/${APP_NAME}-docker-${BUILD_NUMBER}.tar.gz && echo 'Saved to /opt/artifacts/'" || exit 1

# ── STAGE: DEPLOY (симуляция) ─────────────────────────────────
echo -e "${BLUE}━━━ STAGE: DEPLOY ━━━━━━━━━━━━━━━━━━━━${NC}"

step "Stop old container (если был)"     "docker stop ${APP_NAME}-prod 2>/dev/null; docker rm ${APP_NAME}-prod 2>/dev/null; echo 'Old container removed (or was not running)'" || true

step "Start new container"     "docker run -d --name ${APP_NAME}-prod '$IMAGE_LATEST' sleep 3600 && echo 'Container started'" || exit 1

step "Health check: container is running"     "docker ps | grep '${APP_NAME}-prod'" || exit 1

# ── ИТОГ ──────────────────────────────────────────────────────
PIPELINE_END=$(date +%s)
DURATION=$((PIPELINE_END - PIPELINE_START))

echo -e "${BLUE}==================================${NC}"
echo -e "${GREEN}🎉 Pipeline SUCCESS in ${DURATION}s${NC}"
echo ""
echo "Deployed: $IMAGE_TAG"
echo "Container: ${APP_NAME}-prod"
echo ""
docker ps --filter "name=${APP_NAME}-prod" --format "table {{.Names}}	{{.Status}}	{{.Image}}"
PIPELINE
chmod +x docker-pipeline.sh
```{{execute}}

## Запустите Docker-пайплайн

```bash
bash docker-pipeline.sh
```{{execute}}

## Проверьте результат

```bash
docker ps
```{{execute}}

```bash
docker exec myapp-prod python3 app.py
```{{execute}}

```bash
ls -lh /opt/artifacts/
```{{execute}}

## Очистите контейнер

```bash
docker stop myapp-prod && docker rm myapp-prod
```{{execute}}
