# Шаг 5: Артефакты и версионирование

**Артефакт** — это файл созданный пайплайном: собранный бинарник, архив, Docker-образ, отчёт о тестах. Правильное версионирование артефактов — основа надёжного деплоя и возможности откатиться назад.

## Зачем версионировать?

Представьте что вы задеплоили версию 1.5 и она сломала production. Без версионирования вы не знаете что было в 1.4 и не можете быстро откатиться. С версионированием — `docker pull myapp:1.4` и готово.

## Создайте систему версионирования

```bash
cd /opt/myapp
```{{execute}}

```bash
cat > version.sh << 'SCRIPT'
#!/bin/bash

# Версия приложения
APP_VERSION="1.0.0"

# Build number — в реальном CI/CD это номер из системы
# GitHub Actions: $GITHUB_RUN_NUMBER
# GitLab CI: $CI_PIPELINE_IID
BUILD_NUMBER="${BUILD_NUMBER:-$(date +%s)}"

# Git commit hash — в реальном CI/CD: $GITHUB_SHA или $CI_COMMIT_SHA
GIT_COMMIT="${GIT_COMMIT:-$(git rev-parse --short HEAD 2>/dev/null || echo 'no-git')}"

# Итоговая версия: semver + build number + commit
FULL_VERSION="${APP_VERSION}-build.${BUILD_NUMBER}-${GIT_COMMIT}"

echo "APP_VERSION=$APP_VERSION"
echo "BUILD_NUMBER=$BUILD_NUMBER"
echo "GIT_COMMIT=$GIT_COMMIT"
echo "FULL_VERSION=$FULL_VERSION"
SCRIPT
chmod +x version.sh
bash version.sh
```{{execute}}

## Создайте версионированный артефакт

```bash
cat > package.sh << 'SCRIPT'
#!/bin/bash

# Получаем версию
APP_VERSION="1.0.0"
BUILD_NUMBER="${BUILD_NUMBER:-001}"
GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo 'abc1234')"
FULL_VERSION="${APP_VERSION}-build.${BUILD_NUMBER}-${GIT_COMMIT}"

ARTIFACTS_DIR="/opt/artifacts"
mkdir -p "$ARTIFACTS_DIR"

echo "Создаём артефакт версии $FULL_VERSION..."

# Создаём архив
ARTIFACT_NAME="myapp-${FULL_VERSION}.tar.gz"
tar czf "${ARTIFACTS_DIR}/${ARTIFACT_NAME}" app.py tests.py

# Создаём метаданные
cat > "${ARTIFACTS_DIR}/${ARTIFACT_NAME%.tar.gz}.meta" << META
version=$FULL_VERSION
build_number=$BUILD_NUMBER
git_commit=$GIT_COMMIT
created_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
files=$(tar tzf "${ARTIFACTS_DIR}/${ARTIFACT_NAME}" | tr '
' ' ')
META

# Создаём симлинк на последнюю версию
ln -sf "${ARTIFACT_NAME}" "${ARTIFACTS_DIR}/myapp-latest.tar.gz"

echo ""
echo "✅ Артефакт создан: ${ARTIFACTS_DIR}/${ARTIFACT_NAME}"
echo ""
echo "Метаданные:"
cat "${ARTIFACTS_DIR}/${ARTIFACT_NAME%.tar.gz}.meta"
SCRIPT
chmod +x package.sh
bash package.sh
```{{execute}}

## Посмотрите на созданные артефакты

```bash
ls -la /opt/artifacts/
```{{execute}}

```bash
# Симлинк всегда указывает на последнюю версию
ls -la /opt/artifacts/myapp-latest.tar.gz
```{{execute}}

## Откат к предыдущей версии — симуляция

```bash
cat > rollback.sh << 'SCRIPT'
#!/bin/bash

ARTIFACTS_DIR="/opt/artifacts"
TARGET_VERSION="${1:-latest}"

echo "=== ROLLBACK ==="
echo "Target version: $TARGET_VERSION"

if [ "$TARGET_VERSION" == "latest" ]; then
    ARTIFACT="${ARTIFACTS_DIR}/myapp-latest.tar.gz"
else
    ARTIFACT="${ARTIFACTS_DIR}/myapp-${TARGET_VERSION}.tar.gz"
fi

if [ ! -f "$ARTIFACT" ]; then
    echo "❌ Артефакт не найден: $ARTIFACT"
    echo "Доступные версии:"
    ls "$ARTIFACTS_DIR"/*.tar.gz 2>/dev/null | grep -v latest
    exit 1
fi

echo "Откатываемся к: $ARTIFACT"
mkdir -p /tmp/rollback-deploy
tar xzf "$ARTIFACT" -C /tmp/rollback-deploy
echo "✅ Откат выполнен в /tmp/rollback-deploy"
ls /tmp/rollback-deploy
SCRIPT
chmod +x rollback.sh
bash rollback.sh
```{{execute}}
