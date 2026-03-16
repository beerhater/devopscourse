# Шаг 7: Итоговое задание

Напишите полноценный CI workflow для Python-проекта самостоятельно.

## 1. Создайте проект

```bash
mkdir -p /opt/final-gha/.github/workflows
cd /opt/final-gha
git init
git config user.email "student@devops.local"
git config user.name "Student"
```{{execute}}

## 2. Приложение `app.py`

```bash
cat > app.py << 'PYEOF'
def fibonacci(n):
    if n <= 0:
        raise ValueError("n должно быть больше 0")
    if n == 1:
        return 0
    if n == 2:
        return 1
    a, b = 0, 1
    for _ in range(2, n):
        a, b = b, a + b
    return b

def is_prime(n):
    if n < 2:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

if __name__ == "__main__":
    print([fibonacci(i) for i in range(1, 11)])
    print([n for n in range(2, 30) if is_prime(n)])
    print("App works!")
PYEOF
```{{execute}}

## 3. Тесты `tests.py`

```bash
cat > tests.py << 'PYEOF'
from app import fibonacci, is_prime

def test_fibonacci():
    assert fibonacci(1) == 0
    assert fibonacci(2) == 1
    assert fibonacci(7) == 8
    assert fibonacci(10) == 34
    try:
        fibonacci(0)
        assert False, "Должно выброситься исключение"
    except ValueError:
        pass
    print("test_fibonacci: OK")

def test_is_prime():
    assert is_prime(2) == True
    assert is_prime(7) == True
    assert is_prime(1) == False
    assert is_prime(4) == False
    print("test_is_prime: OK")

if __name__ == "__main__":
    test_fibonacci()
    test_is_prime()
    print("Все тесты прошли!")
PYEOF
```{{execute}}

## 4. Workflow `.github/workflows/ci.yml`

Требования:
- Триггеры: `push` и `pull_request`
- Job `lint`: проверка синтаксиса `python3 -m py_compile app.py`
- Job `test`: запуск `python3 tests.py`, ждёт `lint`
- Job `summary`: выводит итог со временем, ждёт `test`
- Переменная `APP_NAME: fibonacci-app` на уровне workflow

```bash
cat > .github/workflows/ci.yml << 'WORKFLOW'
name: CI Pipeline

on:
  push:
  pull_request:

env:
  APP_NAME: "fibonacci-app"

jobs:
  lint:
    name: "Lint"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check syntax
        run: |
          python3 -m py_compile app.py
          echo "$APP_NAME: синтаксис OK"

  test:
    name: "Test"
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: python3 tests.py

  summary:
    name: "Summary"
    runs-on: ubuntu-latest
    needs: test
    steps:
      - name: Print summary
        run: |
          echo "================================"
          echo "  $APP_NAME CI прошёл!"
          echo "  Время: $(date -u)"
          echo "  Событие: ${{ github.event_name }}"
          echo "================================"
WORKFLOW
```{{execute}}

## 5. Запустите

```bash
git add . && git commit -m "Add fibonacci app with CI"
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml')); print('YAML OK')"
```{{execute}}

```bash
act push -W .github/workflows/ci.yml   --pull=false   -P ubuntu-latest=catthehacker/ubuntu:act-latest 2>&1 | grep -E "(Job|Step|print|OK|FAIL|success|failure)" | head -30
```{{execute}}

## 6. Убедитесь что lint защищает от багов

```bash
echo "def broken(: pass" >> app.py
act push -W .github/workflows/ci.yml --pull=false -P ubuntu-latest=catthehacker/ubuntu:act-latest 2>&1 | tail -10
```{{execute}}

Пайплайн должен остановиться на `lint` — до `test` не дойдёт.
