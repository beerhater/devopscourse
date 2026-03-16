# Шаг 3: Триггеры — когда запускать пайплайн

Триггер (`on`) определяет **при каком событии** GitHub запустит workflow.

## Все основные триггеры с примерами

```bash
cd /opt/gh-actions-demo
```{{execute}}

```bash
cat > .github/workflows/triggers-explained.yml << 'WORKFLOW'
name: Triggers Reference

on:
  # Триггер 1: push — при каждом git push
  push:
    branches:
      - main
      - develop
      - "feature/**"   # wildcard: все ветки начинающиеся с feature/
    paths-ignore:
      - "**.md"         # изменение документации не запускает CI

  # Триггер 2: pull_request — при открытии/обновлении PR
  # Используется для проверки кода ПЕРЕД мержем в main
  pull_request:
    branches:
      - main

  # Триггер 3: schedule — по расписанию (как cron)
  schedule:
    - cron: "0 2 * * *"   # каждый день в 2:00 UTC

  # Триггер 4: workflow_dispatch — вручную через кнопку в GitHub UI
  workflow_dispatch:
    inputs:
      environment:
        description: "Куда деплоить?"
        required: true
        default: "staging"
        type: choice
        options:
          - staging
          - production

  # Триггер 5: release — при создании нового релиза
  release:
    types: [published]

jobs:
  placeholder:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Это шпаргалка по триггерам"
WORKFLOW
```{{execute}}

## Когда какой триггер использовать

```bash
cat > /opt/gh-actions-demo/triggers-use-cases.txt << 'EOF'
ПРАКТИКА: когда какой триггер использовать
==========================================

on: pull_request
  Запуск тестов для каждого PR
  Смысл: проверить код ДО попадания в main
  Это основной триггер для CI!

on: push (ветка main)
  Деплой на production после мержа
  Срабатывает когда PR уже одобрен и смержен

on: schedule
  Ночные долгие тесты
  Сканирование безопасности
  Backup базы данных

on: workflow_dispatch
  Деплой по кнопке с выбором окружения
  Maintenance задачи

on: release
  Публикация пакета в PyPI/npm
  Сборка финальных артефактов

GOLDEN RULE:
  CI (тесты)  => on: pull_request
  CD (деплой) => on: push in main
EOF
cat /opt/gh-actions-demo/triggers-use-cases.txt
```{{execute}}

```bash
cat > .github/workflows/ci.yml << 'WORKFLOW'
name: CI — Tests on Every Push

on:
  push:
    branches:
      - main
      - "feature/**"
    paths-ignore:
      - "docs/**"
      - "**.md"
  pull_request:
    branches:
      - main
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Show trigger info
        run: |
          echo "Событие: ${{ github.event_name }}"
          echo "Ветка: ${{ github.ref_name }}"
          echo "Коммит: ${{ github.sha }}"

      - name: Run tests
        run: echo "Тесты прошли!"
WORKFLOW
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml')); print('YAML OK')"
```{{execute}}
