# Шаг 3: include: — разбивка конфига на файлы

## Зачем нужен include:

В реальных проектах `.gitlab-ci.yml` может вырасти до 500–1000 строк. `include:` позволяет разбить его на логические части: отдельный файл для тестов, отдельный для Docker, отдельный для деплоя.

```bash
cat > /opt/gitlab-ci-2-demo/include-explained.txt << 'EOF'
INCLUDE: ТИПЫ ПОДКЛЮЧЕНИЯ
==========================

1. local — файл в том же репозитории
   include:
     - local: "ci/test.yml"
     - local: "ci/docker.yml"

2. project — файл из другого GitLab-проекта
   include:
     - project: "mygroup/ci-templates"
       ref: main
       file: "/templates/python.yml"

3. remote — по URL
   include:
     - remote: "https://example.com/ci/template.yml"

4. template — встроенные шаблоны GitLab
   include:
     - template: "Security/SAST.gitlab-ci.yml"
     - template: "Docker.gitlab-ci.yml"

ПОРЯДОК ВЫПОЛНЕНИЯ:
  Все include-файлы мержатся в один пайплайн.
  stages из всех файлов объединяются.
  Если есть конфликт имён job — последний выигрывает.
EOF
cat /opt/gitlab-ci-2-demo/include-explained.txt
```{{execute}}

```bash
cd /opt/gitlab-ci-2-demo
mkdir -p ci
```{{execute}}

## Создаём отдельные файлы

```bash
cat > ci/variables.yml << 'GLCI'
# ci/variables.yml — глобальные переменные и defaults
variables:
  APP_NAME: "gitlab-demo"
  APP_VERSION: "1.0.0"
  REGISTRY: "localhost:5000"
  IMAGE: "$REGISTRY/mygroup/$APP_NAME"
  PYTHON_VERSION: "3.11"

default:
  before_script:
    - echo ">>> Job: $CI_JOB_NAME | Stage: $CI_JOB_STAGE"
  retry:
    max: 1
    when: [runner_system_failure]
GLCI
```{{execute}}

```bash
cat > ci/test.yml << 'GLCI'
# ci/test.yml — все jobs связанные с тестированием

syntax-check:
  stage: lint
  script:
    - python3 -m py_compile app.py tests.py
    - echo "Синтаксис OK"

unit-tests:
  stage: test
  script:
    - python3 tests.py
  coverage: '/TOTAL.*\s+(\d+%)$/'  # парсим % покрытия из вывода
  artifacts:
    reports:
      junit: report.xml  # если используете pytest --junit-xml
    when: always
    expire_in: 1 week
GLCI
```{{execute}}

```bash
cat > ci/docker.yml << 'GLCI'
# ci/docker.yml — сборка и push Docker-образа

docker-build:
  stage: build
  script:
    - docker build --build-arg APP_VERSION=$APP_VERSION -t $IMAGE:latest .
    - docker push $IMAGE:latest
    - echo "Образ $IMAGE:latest готов"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
    - if: '$CI_COMMIT_TAG'
    - when: never

docker-build-branch:
  stage: build
  script:
    - docker build -t $IMAGE:branch-${CI_COMMIT_REF_SLUG} .
    - echo "Branch образ собран (без push)"
  rules:
    - if: '$CI_COMMIT_BRANCH != "main"'
      when: on_success
GLCI
```{{execute}}

```bash
cat > ci/deploy.yml << 'GLCI'
# ci/deploy.yml — деплой jobs

.deploy-template:
  script:
    - echo "Деплоим $IMAGE на $DEPLOY_ENV..."
    - docker pull $IMAGE:latest
    - docker stop $APP_NAME-$DEPLOY_ENV 2>/dev/null || true
    - docker rm $APP_NAME-$DEPLOY_ENV 2>/dev/null || true
    - docker run -d --name $APP_NAME-$DEPLOY_ENV $IMAGE:latest
    - echo "Деплой на $DEPLOY_ENV завершён!"
  after_script:
    - docker stop $APP_NAME-$DEPLOY_ENV 2>/dev/null || true
    - docker rm $APP_NAME-$DEPLOY_ENV 2>/dev/null || true

deploy-staging:
  extends: .deploy-template
  stage: deploy
  variables:
    DEPLOY_ENV: "staging"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

deploy-production:
  extends: .deploy-template
  stage: deploy
  variables:
    DEPLOY_ENV: "production"
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d/'
  when: manual
GLCI
```{{execute}}

## Главный файл — только include

```bash
cat > .gitlab-ci-include.yml << 'GLCI'
# .gitlab-ci.yml — главный файл, только структура
# Вся логика — в ci/*.yml

stages:
  - lint
  - test
  - build
  - deploy

# Подключаем все части
include:
  - local: "ci/variables.yml"
  - local: "ci/test.yml"
  - local: "ci/docker.yml"
  - local: "ci/deploy.yml"
GLCI
```{{execute}}

```bash
# Проверяем все файлы
python3 -c "
import yaml, os
files = ['.gitlab-ci.yml', '.gitlab-ci-include.yml',
         'ci/variables.yml', 'ci/test.yml', 'ci/docker.yml', 'ci/deploy.yml']
for f in files:
    path = f'/opt/gitlab-ci-2-demo/{f}'
    try:
        yaml.safe_load(open(path))
        print(f'OK  {f}')
    except Exception as e:
        print(f'ERR {f}: {e}')
"
```{{execute}}
