# Шаг 4: Jobs и Steps — единицы работы

## Jobs: параллельность и зависимости

По умолчанию все jobs запускаются **параллельно**. Ключевое слово `needs` задаёт зависимость.

```bash
cd /opt/gh-actions-demo
```{{execute}}

```bash
cat > .github/workflows/multi-job.yml << 'WORKFLOW'
name: Multi-Job Pipeline

on: push

jobs:
  # Job 1: Тесты — запускается первым (нет зависимостей)
  test:
    name: "Run Tests"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Run unit tests
        run: |
          echo "Запускаем тесты..."
          python3 -c "
          assert 2 + 2 == 4, 'FAIL'
          assert 5 - 3 == 2, 'FAIL'
          print('Все тесты прошли!')
          "

  # Job 2: Сборка — ждёт пока test завершится успешно
  # Если test упал — build даже не начнётся
  build:
    name: "Build"
    runs-on: ubuntu-latest
    needs: test
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Build package
        run: |
          mkdir -p dist
          echo "version=1.0.0" > dist/package.txt
          echo "built_at=$(date -u)" >> dist/package.txt
          echo "Пакет собран!"
          cat dist/package.txt

  # Job 3: Deploy — ждёт И test И build
  deploy:
    name: "Deploy"
    runs-on: ubuntu-latest
    needs: [test, build]
    steps:
      - name: Deploy
        run: |
          echo "Все проверки прошли!"
          echo "Деплой выполнен!"
WORKFLOW
```{{execute}}

## Визуализация порядка

```bash
cat << 'EOF'
БЕЗ needs (все параллельно — НЕПРАВИЛЬНО для деплоя):
  0s → [test] [build] [deploy] — все одновременно!
  Проблема: deploy запустится раньше чем тесты пройдут

С needs (правильный порядок):
  0s  → [test] стартует
  30s → [test] OK → [build] стартует
  60s → [build] OK → [deploy] стартует

Параллельность там где возможно:
  0s  → [lint] и [unit-test] стартуют ПАРАЛЛЕЛЬНО
  30s → оба OK → [build] стартует (сэкономили 30s!)
EOF
```{{execute}}

## Steps: run vs uses vs условия

```bash
cat > .github/workflows/steps-demo.yml << 'WORKFLOW'
name: Steps Demo

on: workflow_dispatch

jobs:
  demo:
    runs-on: ubuntu-latest
    steps:
      # Тип 1: простая команда
      - name: Simple command
        run: echo "Простая команда"

      # Тип 2: многострочный скрипт
      - name: Multi-line script
        run: |
          echo "Строка 1"
          for i in 1 2 3; do
            echo "Итерация $i"
          done

      # Тип 3: встроенный Python
      - name: Python inline
        shell: python
        run: |
          result = 2 ** 10
          print(f"2^10 = {result}")

      # Тип 4: готовое Action из маркетплейса
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      # Тип 5: условный шаг — выполняется только в ветке main
      - name: Only on main branch
        if: github.ref_name == 'main'
        run: echo "Этот шаг только в main"

      # Тип 6: выполнится ВСЕГДА, даже если выше были ошибки
      - name: Cleanup (always)
        if: always()
        run: echo "Этот шаг выполняется даже при ошибке"
WORKFLOW
```{{execute}}

```bash
python3 -c "
import yaml, os
workflows = '/opt/gh-actions-demo/.github/workflows'
for f in sorted(os.listdir(workflows)):
    try:
        yaml.safe_load(open(f'{workflows}/{f}'))
        print(f'OK  {f}')
    except Exception as e:
        print(f'ERR {f}: {e}')
"
```{{execute}}
