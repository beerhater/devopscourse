# Шаг 1: Что такое GitHub Actions и как это работает

## Концепция: Events → Workflows → Jobs → Steps

GitHub Actions работает по простой цепочке:

```
Событие (Event)
    │  "произошёл push в ветку main"
    ▼
Workflow (Пайплайн)
    │  читает файл .github/workflows/ci.yml
    ▼
Job (Группа задач)
    │  запускается на Runner (виртуальная машина)
    ▼
Steps (Шаги)
    ├── Step 1: Checkout кода
    ├── Step 2: Установить зависимости
    ├── Step 3: Запустить тесты
    └── Step 4: Собрать Docker-образ
```

**Каждое звено цепочки важно — давайте разберём каждое.**

## Event (Событие)

Событие — это то, что **запускает** workflow. Примеры:
- `push` — кто-то сделал git push
- `pull_request` — открыт Pull Request
- `schedule` — по расписанию (как cron)
- `workflow_dispatch` — вручную через кнопку в UI
- `release` — создан новый релиз

## Workflow (Рабочий процесс)

Workflow — это **весь пайплайн**, описанный в одном YAML-файле. Файл живёт в папке `.github/workflows/` репозитория. Один репозиторий может иметь несколько workflow: например `ci.yml` для тестов и `deploy.yml` для деплоя.

## Job (Задание)

Job — это **группа шагов**, которая выполняется на одной виртуальной машине (runner). Jobs внутри одного workflow по умолчанию выполняются **параллельно**. Если нужна последовательность — используют `needs`.

## Step (Шаг)

Step — это **одна команда или одно действие** внутри job. Шаги выполняются **строго по порядку**. Если шаг упал — job останавливается.

## Runner (Раннер)

Runner — это **виртуальная машина**, на которой выполняется job. GitHub предоставляет бесплатные раннеры: `ubuntu-latest`, `windows-latest`, `macos-latest`.

## Создайте рабочую директорию

```bash
mkdir -p /opt/gh-actions-demo/.github/workflows
cd /opt/gh-actions-demo
```{{execute}}

```bash
cat > /opt/gh-actions-demo/pipeline-explained.txt << 'EOF'
========================================
  КАК РАБОТАЕТ GITHUB ACTIONS
========================================

1. Разработчик делает: git push origin main

2. GitHub видит событие "push" и ищет
   файлы в .github/workflows/*.yml

3. Находит ci.yml, читает его:
   - on: push — "да, это мой триггер"
   - jobs: test — создаёт Job

4. GitHub берёт свободный Runner
   (виртуальную Ubuntu-машину)
   и запускает на ней Job

5. Job выполняет Steps по порядку:
   OK  Step 1: git clone репозитория
   OK  Step 2: python3 -m pytest
   ERR Step 3: если тесты упали — стоп!

6. Результат:
   - Зелёная галочка = всё OK
   - Красный крест = что-то упало

========================================
EOF
cat /opt/gh-actions-demo/pipeline-explained.txt
```{{execute}}
