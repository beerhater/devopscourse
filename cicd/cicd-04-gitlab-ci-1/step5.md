# Шаг 5: Artifacts и Cache

## Разница между artifacts и cache

Это разные концепции, которые часто путают:

```bash
cat > /opt/gitlab-ci-demo/artifacts-vs-cache.txt << 'EOF'
ARTIFACTS vs CACHE
==================

ARTIFACTS — передача данных МЕЖДУ jobs в одном пайплайне
─────────────────────────────────────────────────────────
Пример: job build создаёт dist/, job deploy нужен dist/
  build-job:
    script: mkdir dist && cp app.py dist/
    artifacts:
      paths: [dist/]      ← сохранить эти файлы

  deploy-job:
    needs: [build-job]    ← artifacts build-job
    script: ls dist/      ← автоматически доступны!

Когда удаляются: через expire_in (1 day, 1 week...)
Доступны: для скачивания в UI GitLab

CACHE — ускорение МЕЖДУ запусками пайплайна
────────────────────────────────────────────
Пример: node_modules/ или .venv/ — зачем качать каждый раз?
  test-job:
    script:
      - pip install -r requirements.txt
      - pytest
    cache:
      key: $CI_COMMIT_REF_NAME   ← отдельный кэш для каждой ветки
      paths: [.venv/]            ← что кэшировать

Когда удаляется: через expire_in или вручную
Доступен: только на том же runner

ПРАВИЛО:
  Нужно передать файлы следующему job  → artifacts
  Нужно ускорить установку зависимостей → cache
EOF
cat /opt/gitlab-ci-demo/artifacts-vs-cache.txt
```{{execute}}

```bash
cd /opt/gitlab-ci-demo
```{{execute}}

## Практический пример с artifacts

```bash
cat > artifacts-demo.gitlab-ci.yml << 'GLCI'
stages: [build, test, deploy]

variables:
  APP_VERSION: "1.0.0"

# ── JOB 1: Сборка — создаёт артефакты ─────────────────────────
build:
  stage: build
  script:
    - echo "Собираем приложение..."
    - mkdir -p dist/
    - echo "version: $APP_VERSION" > dist/app-info.txt
    - echo "built_at: $(date -u)" >> dist/app-info.txt
    - cp app.py dist/ 2>/dev/null || echo "app.py не найден, создаём stub"
    - echo "print('Hello from v$APP_VERSION')" > dist/app.py
    - echo "Сборка завершена!"
    - ls -la dist/
  artifacts:
    # Какие файлы сохранить
    paths:
      - dist/
    # Сохранить также если job упал (полезно для логов)
    when: always
    # Через сколько удалить с GitLab-сервера
    expire_in: 1 week
    # name: — имя архива для скачивания в UI
    name: "$CI_JOB_NAME-$CI_COMMIT_SHORT_SHA"

# ── JOB 2: Тест — использует артефакты build ──────────────────
test-artifact:
  stage: test
  # needs: указывает что мы зависим от build
  # автоматически скачает артефакты build!
  needs: [build]
  script:
    - echo "Тестируем артефакт..."
    - ls -la dist/
    - cat dist/app-info.txt
    - python3 dist/app.py
    - echo "Артефакт работает!"

# ── JOB 3: Deploy — тоже использует артефакты ─────────────────
deploy:
  stage: deploy
  needs: [build, test-artifact]
  script:
    - echo "Деплоим артефакт..."
    - cat dist/app-info.txt
    - echo "Деплой v$APP_VERSION завершён!"
GLCI
```{{execute}}

## Практический пример с cache

```bash
cat > cache-demo.gitlab-ci.yml << 'GLCI'
stages: [install, test]

# ── ВАРИАНТ 1: кэш по ветке ────────────────────────────────────
# У каждой ветки свой кэш
test-with-branch-cache:
  stage: test
  image: python:3.11-slim
  variables:
    PIP_CACHE_DIR: "$CI_PROJECT_DIR/.pip-cache"
  cache:
    # key — уникальный идентификатор кэша
    # Если key изменился — кэш сбрасывается
    key: "pip-$CI_COMMIT_REF_SLUG"  # pip-main, pip-develop, pip-feature-xyz
    paths:
      - .pip-cache/
    # policy: pull-push — читать и записывать кэш (по умолчанию)
    # policy: pull      — только читать (быстрее, если не обновляем зависимости)
    # policy: push      — только записывать
    policy: pull-push
  script:
    - pip install --cache-dir .pip-cache pytest 2>/dev/null || true
    - echo "Зависимости установлены (из кэша при повторном запуске)"
    - python3 -c "print('Тест прошёл!')"

# ── ВАРИАНТ 2: кэш по содержимому requirements.txt ────────────
# Кэш сбросится только когда изменится requirements.txt
test-with-smart-cache:
  stage: test
  cache:
    key:
      files:
        - requirements.txt    # хэш файла как ключ кэша
    paths:
      - .venv/
  script:
    - python3 -m venv .venv 2>/dev/null || true
    - echo "pip зависимости установлены"
    - python3 -c "print('Smart cache test OK')"
GLCI
```{{execute}}

```bash
python3 -c "
import yaml
for f in ['artifacts-demo.gitlab-ci.yml', 'cache-demo.gitlab-ci.yml']:
    try:
        yaml.safe_load(open(f'/opt/gitlab-ci-demo/{f}'))
        print(f'OK  {f}')
    except Exception as e:
        print(f'ERR {f}: {e}')
"
```{{execute}}
