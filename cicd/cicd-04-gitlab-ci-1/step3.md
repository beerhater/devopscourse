# Шаг 3: Stages — порядок выполнения

## Как stages управляют порядком

`stages` — это **объявление порядка**. Вы один раз определяете список stages сверху файла, и GitLab CI гарантирует: все jobs stage N завершатся прежде чем начнётся stage N+1.

```bash
cd /opt/gitlab-ci-demo
```{{execute}}

```bash
cat > stages-demo.gitlab-ci.yml << 'GLCI'
# Порядок stages — самая важная часть файла
# GitLab выполнит их строго в этом порядке
stages:
  - validate    # 1. Быстрые проверки
  - test        # 2. Тесты
  - build       # 3. Сборка
  - scan        # 4. Сканирование безопасности
  - deploy      # 5. Деплой

variables:
  APP: "demo"

# ─── STAGE: validate ──────────────────────────────────────────
# Два job в одном stage — запустятся ПАРАЛЛЕЛЬНО
syntax-check:
  stage: validate
  script:
    - echo "[validate] Проверяем синтаксис..."
    - python3 -c "print('Синтаксис Python OK')"

config-check:
  stage: validate
  script:
    - echo "[validate] Проверяем конфиг..."
    - python3 -c "import json; print('JSON парсер работает')"

# ─── STAGE: test ──────────────────────────────────────────────
# Тоже два job параллельно, но ПОСЛЕ validate
unit-tests:
  stage: test
  script:
    - echo "[test] Unit тесты..."
    - python3 -c "assert 2+2==4; print('unit tests: OK')"

integration-tests:
  stage: test
  script:
    - echo "[test] Integration тесты..."
    - python3 -c "assert 'hello'.upper()=='HELLO'; print('integration tests: OK')"

# ─── STAGE: build ─────────────────────────────────────────────
build-package:
  stage: build
  script:
    - echo "[build] Сборка пакета..."
    - mkdir -p dist
    - echo "app=$APP" > dist/info.txt
    - echo "built=$(date -u)" >> dist/info.txt
    - cat dist/info.txt
  artifacts:
    paths: [dist/]
    expire_in: 30 min

# ─── STAGE: scan ──────────────────────────────────────────────
security-scan:
  stage: scan
  script:
    - echo "[scan] Сканирование безопасности..."
    - echo "Проверяем известные уязвимости..."
    - python3 -c "print('Уязвимостей не найдено')"

# ─── STAGE: deploy ────────────────────────────────────────────
deploy-staging:
  stage: deploy
  script:
    - echo "[deploy] Деплоим на staging..."
    - ls dist/
    - echo "Деплой завершён!"
  only:
    - main
GLCI
```{{execute}}

## Что происходит если stage упал

```bash
cat > failing-stage.gitlab-ci.yml << 'GLCI'
stages:
  - test
  - build
  - deploy

unit-tests:
  stage: test
  script:
    - echo "Запускаем тесты..."
    - python3 -c "assert 1 == 2, 'Тест провалился!'"  # ← УПАДЁТ

build-app:
  stage: build
  script:
    - echo "Этот job НЕ запустится — stage test упал!"

deploy-app:
  stage: deploy
  script:
    - echo "Этот тоже НЕ запустится"
GLCI
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('stages-demo.gitlab-ci.yml')); print('stages-demo: OK')"
python3 -c "import yaml; yaml.safe_load(open('failing-stage.gitlab-ci.yml')); print('failing-stage: OK')"
```{{execute}}

## Специальные stages

```bash
cat > special-stages.gitlab-ci.yml << 'GLCI'
# GitLab имеет два встроенных специальных stage:
# .pre  — выполняется ПЕРЕД всеми stages
# .post — выполняется ПОСЛЕ всех stages

stages:
  - test
  - build

# .pre — всегда первый, даже если не объявлен в stages
setup-environment:
  stage: .pre
  script:
    - echo "Подготовка окружения (всегда первым)"
    - echo "CI_PIPELINE_ID=\$CI_PIPELINE_ID"

run-tests:
  stage: test
  script:
    - echo "Тесты..."

build-app:
  stage: build
  script:
    - echo "Сборка..."

# .post — всегда последний
cleanup:
  stage: .post
  script:
    - echo "Очистка после пайплайна (всегда последним)"
    - echo "Удаляем временные файлы..."
  when: always  # выполнить даже если пайплайн упал
GLCI
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('special-stages.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}
