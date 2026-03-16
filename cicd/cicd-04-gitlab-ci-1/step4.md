# Шаг 4: Jobs — настройка и управление

## Анатомия job

Job в GitLab CI имеет много настроек. Разберём каждую:

```bash
cd /opt/gitlab-ci-demo
```{{execute}}

```bash
cat > jobs-anatomy.gitlab-ci.yml << 'GLCI'
stages: [test, build, deploy]

variables:
  GLOBAL_VAR: "доступна везде"

# ── Полная анатомия job ────────────────────────────────────────
full-featured-job:
  stage: test

  # image: — Docker-образ для этого job
  # Переопределяет default image
  image: python:3.11-slim

  # variables: — переменные только для этого job
  variables:
    JOB_VAR: "только для этого job"
    MY_NAME: "full-featured-job"

  # before_script: — выполняется ДО script
  # Если задан в job — переопределяет глобальный before_script
  before_script:
    - echo "=== before_script: подготовка ==="
    - pip install --quiet pytest 2>/dev/null || true

  # script: — основные команды (ОБЯЗАТЕЛЬНОЕ поле)
  script:
    - echo "=== script: основная работа ==="
    - echo "Global: $GLOBAL_VAR"
    - echo "Job var: $JOB_VAR"
    - python3 -c "print('Job выполняется!')"

  # after_script: — выполняется ПОСЛЕ script
  # Выполняется ВСЕГДА, даже если script упал
  after_script:
    - echo "=== after_script: завершение ==="
    - echo "Job $MY_NAME завершён"

  # when: — когда запускать job
  # on_success (по умолчанию) — только если предыдущий stage OK
  # on_failure — только если предыдущий stage упал
  # always     — всегда
  # manual     — только по кнопке в UI
  # never      — никогда (для отключения)
  when: on_success

  # allow_failure: true — job может упасть, пайплайн продолжится
  allow_failure: false

  # timeout: — максимальное время выполнения
  timeout: 10 minutes

  # retry: — повторить если упал (из-за сетевых ошибок и т.д.)
  retry:
    max: 2
    when:
      - runner_system_failure
      - stuck_or_timeout_failure

# ── Условный запуск: rules ────────────────────────────────────
# rules: — современный способ управлять когда запускать job
# Заменяет устаревшие only:/except:
smart-deploy:
  stage: deploy
  script:
    - echo "Деплоим..."
  rules:
    # Запускать автоматически только в ветке main
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: on_success
    # Для тегов v* — тоже запускать
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
      when: on_success
    # Для всех остальных — запускать вручную
    - when: manual

# ── Устаревший способ: only/except ────────────────────────────
# Всё ещё распространён, важно понимать
old-style-deploy:
  stage: deploy
  script:
    - echo "Деплой через only/except"
  only:
    - main           # только ветка main
    - tags           # и теги
  except:
    - schedules      # но не при scheduled pipeline

# ── needs: зависимость между jobs одного stage ────────────────
# Обычно jobs внутри stage параллельны
# needs: позволяет создать зависимость без нового stage
job-a:
  stage: build
  script: echo "job-a"

job-b:
  stage: build
  needs: [job-a]    # ждёт job-a, хотя оба в stage build
  script: echo "job-b запустится только после job-a"
GLCI
```{{execute}}

## when: — управление запуском jobs

```bash
cat > when-demo.gitlab-ci.yml << 'GLCI'
stages: [test, notify, deploy]

run-tests:
  stage: test
  script:
    - echo "Запускаем тесты..."
    - python3 -c "assert True, 'OK'"

# on_failure — запустить только если stage test упал
# Полезно для уведомлений о провале
notify-on-failure:
  stage: notify
  script:
    - echo "ТЕСТЫ УПАЛИ! Отправляем уведомление в Slack..."
  when: on_failure

# always — запустить в любом случае
# Полезно для cleanup
cleanup-always:
  stage: notify
  script:
    - echo "Очищаем временные файлы (всегда)..."
  when: always

# manual — требует нажатия кнопки в UI GitLab
# Полезно для деплоя — чтобы случайно не задеплоить
deploy-production:
  stage: deploy
  script:
    - echo "Деплоим на PRODUCTION..."
    - echo "Это опасная операция — требует ручного подтверждения"
  when: manual
  # allow_failure: true — пайплайн считается успешным
  # даже если этот job не запущен вручную
  allow_failure: true
GLCI
```{{execute}}

```bash
python3 -c "
import yaml, os
for f in ['jobs-anatomy.gitlab-ci.yml', 'when-demo.gitlab-ci.yml']:
    try:
        yaml.safe_load(open(f'/opt/gitlab-ci-demo/{f}'))
        print(f'OK  {f}')
    except Exception as e:
        print(f'ERR {f}: {e}')
"
```{{execute}}
