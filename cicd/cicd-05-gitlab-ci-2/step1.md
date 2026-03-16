# Шаг 1: GitLab Container Registry

## Что такое GitLab Container Registry

В GitHub вы пушили образы в **Docker Hub** — внешний сервис. GitLab предоставляет **встроенный Docker registry** прямо внутри GitLab-сервера. Образы хранятся рядом с кодом.

```bash
cat > /opt/gitlab-ci-2-demo/registry-explained.txt << 'EOF'
GITLAB CONTAINER REGISTRY
==========================

БЕЗ GitLab Registry (как в GitHub Actions):
  Код → GitHub → Docker Hub ← Сервер
  Нужна авторизация в Docker Hub, управление токенами

С GitLab Container Registry:
  Код → GitLab → GitLab Registry ← Сервер
  Авторизация автоматическая через встроенные переменные!

ВСТРОЕННЫЕ ПЕРЕМЕННЫЕ (заполняются GitLab автоматически):
  $CI_REGISTRY          = registry.gitlab.com
  $CI_REGISTRY_IMAGE    = registry.gitlab.com/group/project
  $CI_REGISTRY_USER     = gitlab-ci-token
  $CI_REGISTRY_PASSWORD = (токен, генерируется на время job)

АДРЕС ОБРАЗА:
  registry.gitlab.com/mygroup/myproject:latest
  registry.gitlab.com/mygroup/myproject:v1.2.3
  registry.gitlab.com/mygroup/myproject:sha-abc1234

DOCKER PULL С АВТОРИЗАЦИЕЙ:
  docker login registry.gitlab.com -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD
  docker pull $CI_REGISTRY_IMAGE:latest
EOF
cat /opt/gitlab-ci-2-demo/registry-explained.txt
```{{execute}}

## Авторизация в Registry внутри пайплайна

```bash
cd /opt/gitlab-ci-2-demo
```{{execute}}

```bash
cat > registry-auth-demo.gitlab-ci.yml << 'GLCI'
stages:
  - build
  - deploy

variables:
  # Если работаем с GitLab Registry — используем встроенные переменные
  # Они заполняются автоматически, не нужно ничего настраивать
  IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
  IMAGE_LATEST: $CI_REGISTRY_IMAGE:latest

build-image:
  stage: build
  # Для docker build нужен Docker-in-Docker (dind) или shell runner
  # image: docker:24 — образ с установленным Docker
  image: docker:24
  services:
    # services: — дополнительные контейнеры запущенные рядом с job
    # docker:24-dind — Docker daemon (без него docker build не работает в контейнере)
    - docker:24-dind
  variables:
    # DOCKER_TLS_CERTDIR: "" — отключаем TLS для простоты (в проде включайте!)
    DOCKER_TLS_CERTDIR: ""
  before_script:
    # Авторизуемся в GitLab Container Registry
    # $CI_REGISTRY_USER и $CI_REGISTRY_PASSWORD — автоматические переменные GitLab
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $IMAGE -t $IMAGE_LATEST .
    - docker push $IMAGE
    - docker push $IMAGE_LATEST
    - echo "Образ запушен: $IMAGE"

deploy-staging:
  stage: deploy
  script:
    # Авторизация для pull образа на сервере деплоя
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker pull $IMAGE
    - echo "Деплоим $IMAGE на staging"
  only:
    - main
GLCI
```{{execute}}

## Локальная симуляция: поднимаем свой registry

Так как GitLab.com нам недоступен — создадим локальный registry и будем работать с ним:

```bash
# Запускаем локальный Docker registry
docker run -d --name local-registry   -p 5000:5000   --restart=unless-stopped   registry:2
echo "Локальный registry запущен на localhost:5000"
```{{execute}}

```bash
# Проверяем
curl -s http://localhost:5000/v2/ && echo "Registry работает!"
```{{execute}}

```bash
# Создадим переменные которые имитируют $CI_REGISTRY_*
# В реальном GitLab они заполняются автоматически
cat > /opt/gitlab-ci-2-demo/simulate-gitlab-vars.sh << 'EOF'
#!/bin/bash
# Симулируем переменные GitLab CI
export CI_REGISTRY="localhost:5000"
export CI_REGISTRY_IMAGE="localhost:5000/mygroup/myapp"
export CI_COMMIT_SHORT_SHA="abc12345"
export CI_COMMIT_REF_NAME="main"
export CI_PROJECT_NAME="myapp"
export CI_PIPELINE_ID="42"
export CI_JOB_ID="100"
echo "GitLab CI переменные установлены:"
echo "  CI_REGISTRY=$CI_REGISTRY"
echo "  CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE"
echo "  CI_COMMIT_SHORT_SHA=$CI_COMMIT_SHORT_SHA"
EOF
chmod +x /opt/gitlab-ci-2-demo/simulate-gitlab-vars.sh
source /opt/gitlab-ci-2-demo/simulate-gitlab-vars.sh
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('/opt/gitlab-ci-2-demo/registry-auth-demo.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}
