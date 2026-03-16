# Шаг 5: Environments — трекинг деплоев

## Что такое Environments в GitLab

**Environment** — это именованное окружение (staging, production, review) которое GitLab трекит. В UI GitLab видно:

- Куда и когда был сделан последний деплой
- Какая версия сейчас на каждом окружении
- Историю всех деплоев
- Кнопку "Rollback" — откат к предыдущей версии

```bash
cd /opt/gitlab-ci-2-demo
```{{execute}}

```bash
cat > /opt/gitlab-ci-2-demo/environments-explained.txt << 'EOF'
ENVIRONMENTS В GITLAB
======================

В GitLab UI (Deployments → Environments) видно:

  staging     → v1.2.3  (deployed 5 min ago by @john)  [Re-deploy] [Stop]
  production  → v1.1.0  (deployed 2 days ago by @jane)  [Re-deploy] [Stop]

Каждый деплой создаёт Deployment:
  #42  main  abc1234  deployed  5 min ago  ✅

ТИПЫ ОКРУЖЕНИЙ:
  Статические:  staging, production — живут всегда
  Динамические: review/feature-xyz — создаются для каждого MR,
                удаляются когда MR закрывается

ЗАЧЕМ ЭТО НУЖНО:
  - Видеть что сейчас на проде одним взглядом
  - Быстро откатиться если что-то сломалось
  - Аудит: кто и когда делал деплой
  - Review Apps: автоматический preview для каждого MR
EOF
cat /opt/gitlab-ci-2-demo/environments-explained.txt
```{{execute}}

## Workflow с Environments

```bash
cat > environments.gitlab-ci.yml << 'GLCI'
stages:
  - test
  - build
  - deploy

variables:
  IMAGE: "localhost:5000/myapp"
  APP_NAME: "myapp"

test:
  stage: test
  script:
    - python3 tests.py

build:
  stage: build
  script:
    - docker build -t $IMAGE:${CI_COMMIT_SHORT_SHA:-local} .
    - docker push $IMAGE:${CI_COMMIT_SHORT_SHA:-local} 2>/dev/null || true
    - echo "Образ собран"

# ── Деплой на staging ─────────────────────────────────────────
deploy-staging:
  stage: deploy
  script:
    - echo "Деплоим на staging..."
    - docker stop $APP_NAME-staging 2>/dev/null || true
    - docker rm $APP_NAME-staging 2>/dev/null || true
    - docker run -d --name $APP_NAME-staging $IMAGE:${CI_COMMIT_SHORT_SHA:-local} 2>/dev/null ||       echo "Симуляция деплоя на staging"
    - echo "Staging обновлён до ${CI_COMMIT_SHORT_SHA:-local}"

  # environment: — ключевое поле для трекинга в GitLab UI
  environment:
    name: staging                           # имя окружения
    url: http://staging.myapp.example.com   # URL (кликабельная ссылка в UI)
    # on_stop: stop-staging                 # job для остановки окружения

  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# ── Деплой на production ───────────────────────────────────────
deploy-production:
  stage: deploy
  script:
    - echo "PRODUCTION DEPLOY: ${CI_COMMIT_SHORT_SHA:-local}"
    - echo "Запускаем zero-downtime деплой..."
    - docker stop $APP_NAME-prod 2>/dev/null || true
    - docker rm $APP_NAME-prod 2>/dev/null || true
    - docker run -d --name $APP_NAME-prod $IMAGE:${CI_COMMIT_SHORT_SHA:-local} 2>/dev/null ||       echo "Симуляция деплоя на production"
    - echo "Production обновлён!"

  environment:
    name: production
    url: http://myapp.example.com

  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d/'    # только для git-тегов v*
  when: manual    # требует ручного подтверждения

# ── Динамические окружения для MR (Review Apps) ────────────────
# Создаёт временное окружение для каждого Merge Request
deploy-review:
  stage: deploy
  script:
    - echo "Создаём review окружение для MR $CI_MERGE_REQUEST_IID..."
    - REVIEW_NAME="review-${CI_COMMIT_REF_SLUG}"
    - docker run -d --name $APP_NAME-$REVIEW_NAME $IMAGE:${CI_COMMIT_SHORT_SHA:-local} 2>/dev/null ||       echo "Симуляция review деплоя"
    - echo "Review app доступен!"

  environment:
    # $CI_COMMIT_REF_SLUG — имя ветки в URL-safe формате (feature/xyz → feature-xyz)
    name: review/$CI_COMMIT_REF_SLUG
    url: http://$CI_COMMIT_REF_SLUG.review.example.com
    on_stop: stop-review    # job для очистки когда MR закрыт

  rules:
    - if: '$CI_MERGE_REQUEST_IID'    # только для MR pipelines

# ── Остановка review окружения ────────────────────────────────
stop-review:
  stage: deploy
  script:
    - REVIEW_NAME="review-${CI_COMMIT_REF_SLUG}"
    - docker stop $APP_NAME-$REVIEW_NAME 2>/dev/null || true
    - docker rm $APP_NAME-$REVIEW_NAME 2>/dev/null || true
    - echo "Review окружение удалено"

  environment:
    name: review/$CI_COMMIT_REF_SLUG
    action: stop    # action: stop — помечает окружение как остановленное

  rules:
    - if: '$CI_MERGE_REQUEST_IID'
      when: manual
GLCI
```{{execute}}

## Запускаем деплой локально

```bash
python3 -c "import yaml; yaml.safe_load(open('environments.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}

```bash
gitlab-runner exec shell deploy-staging --env CI_COMMIT_SHORT_SHA=abc12345 2>&1 | tail -15
```{{execute}}
