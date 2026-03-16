# Шаг 2: Структура .gitlab-ci.yml

Разберём структуру файла **поле за полем**, как делали с GitHub Actions.

## Минимальный рабочий .gitlab-ci.yml

```yaml
stages:         # Определяем порядок stages
  - test
  - build

my-test:        # Имя job — произвольное
  stage: test   # К какому stage относится
  script:       # Список команд (аналог run: в GitHub Actions)
    - echo "Запускаем тесты"
    - python3 -m pytest

my-build:
  stage: build
  script:
    - docker build -t myapp:latest .
```

## Все основные секции

```bash
cd /opt/gitlab-ci-demo
```{{execute}}

```bash
cat > .gitlab-ci.yml << 'GLCI'
# ══════════════════════════════════════════════════════════
# СЕКЦИЯ 1: stages — определяет порядок выполнения
# ══════════════════════════════════════════════════════════
stages:
  - lint      # 1-й: проверка стиля кода
  - test      # 2-й: запуск тестов
  - build     # 3-й: сборка
  - deploy    # 4-й: деплой

# ══════════════════════════════════════════════════════════
# СЕКЦИЯ 2: глобальные переменные — доступны во всех jobs
# ══════════════════════════════════════════════════════════
variables:
  APP_NAME: "my-gitlab-app"
  APP_VERSION: "1.0.0"
  PYTHON_VERSION: "3.11"
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"

# ══════════════════════════════════════════════════════════
# СЕКЦИЯ 3: образ Docker по умолчанию
# Все jobs будут запускаться в этом контейнере
# (если job не переопределяет свой image:)
# ══════════════════════════════════════════════════════════
default:
  image: python:3.11-alpine
  # before_script — выполняется ПЕРЕД script в каждом job
  before_script:
    - echo "=== Запуск job: $CI_JOB_NAME ==="
    - echo "Pipeline: $CI_PIPELINE_ID"
    - python3 --version

# ══════════════════════════════════════════════════════════
# СЕКЦИЯ 4: jobs
# ══════════════════════════════════════════════════════════

# JOB 1: Lint — проверка синтаксиса
check-syntax:
  stage: lint
  script:
    - echo "Проверяем синтаксис Python..."
    - python3 -m py_compile app.py
    - echo "Синтаксис OK"

# JOB 2: Unit тесты
unit-tests:
  stage: test
  script:
    - echo "Запускаем unit тесты..."
    - python3 tests.py
  # after_script — выполняется ПОСЛЕ script, даже если упал
  after_script:
    - echo "Тесты завершены (успешно или нет)"

# JOB 3: Сборка
build-app:
  stage: build
  script:
    - echo "Собираем приложение..."
    - mkdir -p dist
    - cp app.py dist/
    - echo "version=$APP_VERSION" > dist/version.txt
    - echo "Сборка завершена"
  # artifacts — сохранить файлы после job
  # другие jobs смогут их скачать
  artifacts:
    paths:
      - dist/
    expire_in: 1 hour

# JOB 4: Deploy
deploy-staging:
  stage: deploy
  script:
    - echo "Деплоим $APP_NAME v$APP_VERSION на staging..."
    - ls -la dist/   # файлы из artifacts предыдущего job
    - echo "Деплой завершён!"
  # only — запускать только для определённых веток/тегов
  only:
    - main
GLCI
```{{execute}}

## Специальные переменные GitLab CI

```bash
cat > /opt/gitlab-ci-demo/gitlab-variables.txt << 'EOF'
АВТОМАТИЧЕСКИЕ ПЕРЕМЕННЫЕ GITLAB CI (аналог github.* в Actions)
================================================================

$CI_PROJECT_NAME      — имя репозитория (my-project)
$CI_PROJECT_DIR       — путь к коду на раннере (/builds/group/project)
$CI_COMMIT_SHA        — полный SHA коммита
$CI_COMMIT_SHORT_SHA  — короткий SHA (8 символов)
$CI_COMMIT_REF_NAME   — имя ветки или тега (main, develop, v1.2.3)
$CI_COMMIT_BRANCH     — только ветка (не тег)
$CI_COMMIT_TAG        — тег (если это tagged pipeline)
$CI_COMMIT_MESSAGE    — текст коммита
$CI_PIPELINE_ID       — уникальный ID пайплайна
$CI_JOB_ID            — уникальный ID job
$CI_JOB_NAME          — имя job (unit-tests)
$CI_JOB_STAGE         — имя stage (test)
$CI_REGISTRY          — адрес GitLab Container Registry
$CI_REGISTRY_IMAGE    — полный путь к образу (registry.gitlab.com/group/project)
$CI_REGISTRY_USER     — логин для registry
$CI_REGISTRY_PASSWORD — пароль для registry
$GITLAB_USER_LOGIN    — логин пользователя который сделал push

АНАЛОГИ GITHUB ACTIONS:
  $CI_COMMIT_SHA       ↔  ${{ github.sha }}
  $CI_COMMIT_REF_NAME  ↔  ${{ github.ref_name }}
  $CI_JOB_NAME         ↔  ${{ github.job }}
  $CI_PIPELINE_ID      ↔  ${{ github.run_id }}
EOF
cat /opt/gitlab-ci-demo/gitlab-variables.txt
```{{execute}}

## Проверьте YAML

```bash
python3 -c "import yaml; yaml.safe_load(open('/opt/gitlab-ci-demo/.gitlab-ci.yml')); print('YAML синтаксис OK')"
```{{execute}}
