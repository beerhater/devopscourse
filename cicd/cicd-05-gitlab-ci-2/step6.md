# Шаг 6: rules: — сложная логика запуска

## rules: vs only/except

В GitLab CI ч.1 мы видели `only:/except:` — старый способ управления запуском jobs. **`rules:`** — современная замена, гораздо мощнее.

```bash
cat > /opt/gitlab-ci-2-demo/rules-comparison.txt << 'EOF'
ONLY/EXCEPT (устарело, но встречается):
  only:
    - main
    - tags
  except:
    - schedules
  Проблема: нельзя комбинировать условия, нет when: внутри

RULES (современно):
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: on_success
    - if: '$CI_COMMIT_TAG'
      when: on_success
    - when: never
  Плюсы: if + when + changes + exists в одном блоке
         Первое совпавшее правило применяется

ПОРЯДОК ПРАВИЛ ВАЖЕН:
  rules проверяются сверху вниз.
  Первое совпавшее правило — применяется, остальные игнорируются.
  Если ни одно не совпало — job не запускается (как when: never).
EOF
cat /opt/gitlab-ci-2-demo/rules-comparison.txt
```{{execute}}

```bash
cd /opt/gitlab-ci-2-demo
```{{execute}}

```bash
cat > rules-demo.gitlab-ci.yml << 'GLCI'
stages: [test, build, deploy, notify]

variables:
  IMAGE: "localhost:5000/myapp"

# ── Пример 1: if — условие на переменную ──────────────────────
test:
  stage: test
  script: python3 tests.py
  rules:
    # Запускать для любой ветки и для MR — но не по расписанию
    - if: '$CI_PIPELINE_SOURCE == "schedule"'
      when: never          # Исключить scheduled pipelines
    - when: on_success     # Для всех остальных — запускать

# ── Пример 2: changes — только если изменились файлы ──────────
# Экономит время: не запускаем Docker build если Dockerfile не менялся
build-docker:
  stage: build
  script:
    - docker build -t $IMAGE:latest .
    - echo "Docker образ собран"
  rules:
    # Запускать только если изменился Dockerfile или app.py
    - if: '$CI_COMMIT_BRANCH'
      changes:
        - Dockerfile
        - app.py
        - requirements.txt
      when: on_success
    # Всегда запускать для тегов (релиз)
    - if: '$CI_COMMIT_TAG'
      when: on_success
    # В остальных случаях — пропустить
    - when: never

# ── Пример 3: exists — если файл существует ───────────────────
run-if-tests-exist:
  stage: test
  script: python3 tests.py
  rules:
    - exists:
        - "tests.py"
        - "test_*.py"
      when: on_success
    - when: never    # тестов нет — пропускаем job

# ── Пример 4: разное поведение для разных контекстов ──────────
smart-deploy:
  stage: deploy
  script:
    - echo "Деплоим на $DEPLOY_TARGET..."
  rules:
    # main ветка → автоматически на staging
    - if: '$CI_COMMIT_BRANCH == "main"'
      variables:
        DEPLOY_TARGET: "staging"    # переменная только для этого правила!
      when: on_success

    # git-тег v* → вручную на production
    - if: '$CI_COMMIT_TAG =~ /^v[0-9]/'
      variables:
        DEPLOY_TARGET: "production"
      when: manual

    # develop ветка → автоматически на dev
    - if: '$CI_COMMIT_BRANCH == "develop"'
      variables:
        DEPLOY_TARGET: "dev"
      when: on_success

    # MR → вручную на review
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      variables:
        DEPLOY_TARGET: "review"
      when: manual

    # Всё остальное — не деплоить
    - when: never

# ── Пример 5: allow_failure + rules ───────────────────────────
# Экспериментальные проверки — могут падать, не блокируют пайплайн
experimental-security-scan:
  stage: test
  script:
    - echo "Запускаем экспериментальный сканер безопасности..."
    - python3 -c "print('Scan complete: 0 issues')"
  allow_failure: true    # пайплайн продолжится даже если упадёт
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# ── Пример 6: scheduled pipeline — ночные тесты ───────────────
nightly-full-test:
  stage: test
  script:
    - echo "Полный тестовый прогон (только ночью)..."
    - python3 tests.py
  rules:
    - if: '$CI_PIPELINE_SOURCE == "schedule"'
      when: always
    - when: never    # в обычных пайплайнах не запускать

# ── Пример 7: уведомление только при падении ──────────────────
notify-failure:
  stage: notify
  script:
    - echo "ПАЙПЛАЙН УПАЛ!"
    - echo "Ветка: $CI_COMMIT_BRANCH"
    - echo "Отправляем уведомление..."
  rules:
    - when: on_failure    # только если что-то выше упало
GLCI
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('rules-demo.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}

## Запускаем jobs с кастомными переменными

```bash
# Симулируем main-ветку
gitlab-runner exec shell test --env CI_PIPELINE_SOURCE=push --env CI_COMMIT_BRANCH=main 2>&1 | tail -10
```{{execute}}

```bash
# Запускаем run-if-tests-exist — файл tests.py есть, должен сработать
gitlab-runner exec shell run-if-tests-exist 2>&1 | tail -10
```{{execute}}
