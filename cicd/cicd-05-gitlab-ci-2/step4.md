# Шаг 4: extends: и YAML anchors — переиспользование

## Проблема копипасты в CI конфигах

В больших проектах много похожих jobs: деплой на staging, на production, на preview. Они отличаются только парой переменных, но код копируется целиком. Это плохо — при изменении нужно обновлять все копии.

GitLab предлагает два решения: **`extends:`** и **YAML anchors**.

```bash
cd /opt/gitlab-ci-2-demo
```{{execute}}

## extends: — наследование от шаблона

```bash
cat > extends-demo.gitlab-ci.yml << 'GLCI'
stages: [test, build, deploy]

variables:
  IMAGE: "localhost:5000/myapp"

# ── Шаблон с точкой в начале имени ────────────────────────────
# Jobs с именем начинающимся на "." — скрытые (не запускаются сами)
# Их используют только как шаблоны для extends:
.base-test:
  stage: test
  before_script:
    - echo "Подготовка к тестам"
    - python3 --version
  after_script:
    - echo "Тесты завершены: $CI_JOB_NAME"
  artifacts:
    when: always
    expire_in: 1 day

.base-deploy:
  stage: deploy
  before_script:
    - echo "Подготовка деплоя на $DEPLOY_ENV"
    - docker pull $IMAGE:latest
  after_script:
    - echo "Деплой на $DEPLOY_ENV завершён"

# ── Jobs которые наследуют шаблон ─────────────────────────────
# extends: копирует всё из шаблона, потом мержит с текущим job
# Текущие поля перезаписывают поля шаблона

unit-tests:
  extends: .base-test    # наследуем before_script, after_script, artifacts
  script:
    - python3 tests.py   # только script — свой

integration-tests:
  extends: .base-test
  script:
    - python3 -c "print('Integration tests OK')"
  # Переопределяем одно поле из шаблона:
  artifacts:
    paths: [test-results/]
    expire_in: 1 week    # другое время хранения

# ── Деплой: три окружения, один шаблон ────────────────────────
deploy-dev:
  extends: .base-deploy
  variables:
    DEPLOY_ENV: "dev"
    PORT: "8081"
  script:
    - docker run -d --name app-dev -p $PORT:8080 $IMAGE:latest
    - echo "Dev запущен на порту $PORT"
  rules:
    - if: '$CI_COMMIT_BRANCH != "main"'

deploy-staging:
  extends: .base-deploy
  variables:
    DEPLOY_ENV: "staging"
    PORT: "8082"
  script:
    - docker run -d --name app-staging -p $PORT:8080 $IMAGE:latest
    - echo "Staging запущен на порту $PORT"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

deploy-production:
  extends: .base-deploy
  variables:
    DEPLOY_ENV: "production"
    PORT: "80"
  script:
    - echo "PRODUCTION DEPLOY!"
    - docker run -d --name app-prod -p $PORT:8080 $IMAGE:latest
  rules:
    - if: '$CI_COMMIT_TAG'
  when: manual

# ── Множественное наследование (GitLab 12.0+) ─────────────────
.notifications:
  after_script:
    - echo "Отправляем уведомление в Slack..."

deploy-with-notify:
  extends:
    - .base-deploy      # берём логику деплоя
    - .notifications    # добавляем уведомления
  variables:
    DEPLOY_ENV: "preview"
  script:
    - echo "Preview deploy"
GLCI
```{{execute}}

## YAML anchors — нативный YAML способ

```bash
cat > anchors-demo.gitlab-ci.yml << 'GLCI'
stages: [test, deploy]

# YAML anchor определяется через &имя
# Используется через *имя (копирует значение)
# Мерж блоков: <<: *имя (мержит поля)

# Определяем якорь
.common-variables: &common-variables
  APP_NAME: "demo"
  REGISTRY: "localhost:5000"
  IMAGE: "localhost:5000/demo"

# Определяем якорь для before_script
.setup-steps: &setup-steps
  - echo "=== $CI_JOB_NAME started ==="
  - python3 --version

# Используем якоря
test-job:
  stage: test
  variables:
    # <<: *common-variables — вставляет все поля из якоря
    <<: *common-variables
    EXTRA_VAR: "только для этого job"
  before_script: *setup-steps    # копируем список команд
  script:
    - echo "Testing $APP_NAME"
    - python3 tests.py

deploy-job:
  stage: deploy
  variables:
    <<: *common-variables    # те же переменные
  before_script: *setup-steps
  script:
    - echo "Deploying $IMAGE"
GLCI
```{{execute}}

## extends: vs YAML anchors — когда что использовать

```bash
cat << 'EOF'
extends:                        YAML anchors (&/*):
────────────────────────────    ────────────────────────────
Работает через GitLab UI        Стандартный YAML
Видно в "Expanded CI config"    Работает в любом YAML парсере
Можно наследовать из include:   Только в одном файле
Рекомендован GitLab             Устаревший подход

ВЫВОД: используйте extends: — это современный GitLab-способ
EOF
```{{execute}}

```bash
python3 -c "
import yaml
for f in ['extends-demo.gitlab-ci.yml', 'anchors-demo.gitlab-ci.yml']:
    try:
        yaml.safe_load(open(f'/opt/gitlab-ci-2-demo/{f}'))
        print(f'OK  {f}')
    except Exception as e:
        print(f'ERR {f}: {e}')
"
```{{execute}}
