# Шаг 6: Запускаем workflow локально через act

**`act`** читает `.github/workflows/*.yml` и запускает их в Docker-контейнерах. Тот же синтаксис что на GitHub, но без интернета.

## Устанавливаем act

```bash
if ! which act > /dev/null 2>&1; then
  cd /tmp
  wget -qO act.tar.gz https://github.com/nektos/act/releases/latest/download/act_Linux_x86_64.tar.gz
  tar xzf act.tar.gz && mv act /usr/local/bin/ && chmod +x /usr/local/bin/act
fi
act --version
```{{execute}}

## Инициализируем git-репозиторий

`act` требует чтобы папка была git-репозиторием:

```bash
cd /opt/gh-actions-demo
git init
git config user.email "student@devops.local"
git config user.name "DevOps Student"
git add .
git commit -m "Initial commit"
```{{execute}}

## Создаём workflow для запуска

```bash
cat > .github/workflows/local-test.yml << 'WORKFLOW'
name: Local Test Workflow

on: push

jobs:
  test:
    name: "Run Tests"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Show environment
        run: |
          echo "OS: $(uname -s)"
          echo "Python: $(python3 --version)"
          echo "User: $(whoami)"

      - name: Run calculations
        run: |
          python3 << 'PYEOF'
          print("=== Тесты ===")
          def add(a, b): return a + b
          def multiply(a, b): return a * b
          assert add(2, 3) == 5
          print("test_add: OK")
          assert multiply(4, 5) == 20
          print("test_multiply: OK")
          print("Все тесты прошли!")
          PYEOF

      - name: Create artifact
        run: |
          mkdir -p artifacts
          echo "timestamp=$(date -u)" > artifacts/build-info.txt
          cat artifacts/build-info.txt

      - name: Final step
        run: echo "Pipeline завершён успешно!"
WORKFLOW
```{{execute}}

## Запускаем

```bash
act push -W .github/workflows/local-test.yml   --pull=false   -P ubuntu-latest=catthehacker/ubuntu:act-latest 2>&1 | head -80
```{{execute}}

> Первый запуск скачает Docker-образ раннера (~800MB) — это займёт пару минут. Последующие запуски мгновенные.

## Полезные команды act

```bash
# Показать список всех workflow и jobs
act --list
```{{execute}}

```bash
# Сухой запуск — что будет выполнено, без реального запуска
act push --dryrun
```{{execute}}

## Демонстрация падения пайплайна

```bash
cat > .github/workflows/failing-test.yml << 'WORKFLOW'
name: Failing Pipeline Demo

on: push

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Step 1 — OK
        run: echo "Шаг 1 прошёл"

      - name: Step 2 — FAIL
        run: python3 -c "assert 1 == 2, 'Тест упал!'"

      - name: Step 3 — НЕ ВЫПОЛНИТСЯ
        run: echo "До этого шага не доберёмся"
WORKFLOW
```{{execute}}

```bash
act push -W .github/workflows/failing-test.yml   --pull=false   -P ubuntu-latest=catthehacker/ubuntu:act-latest 2>&1 | tail -20
```{{execute}}

Шаг 3 не выполнился — пайплайн остановился на Step 2.
