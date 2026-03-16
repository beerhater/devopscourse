# Шаг 7: Итоговое задание

Напишите полноценный `.gitlab-ci.yml` для Python-проекта с calculatorом.

## 1. Создайте проект

```bash
mkdir -p /opt/final-gitlab-ci
cd /opt/final-gitlab-ci
```{{execute}}

## 2. Приложение `calculator.py`

```bash
cat > calculator.py << 'PYEOF'
class Calculator:
    def add(self, a, b):
        return a + b

    def subtract(self, a, b):
        return a - b

    def multiply(self, a, b):
        return a * b

    def divide(self, a, b):
        if b == 0:
            raise ValueError("Деление на ноль!")
        return a / b

    def power(self, base, exp):
        return base ** exp

if __name__ == "__main__":
    calc = Calculator()
    print(f"2 + 3 = {calc.add(2, 3)}")
    print(f"10 / 4 = {calc.divide(10, 4)}")
    print(f"2 ^ 8 = {calc.power(2, 8)}")
PYEOF
```{{execute}}

## 3. Тесты `test_calculator.py`

```bash
cat > test_calculator.py << 'PYEOF'
from calculator import Calculator

calc = Calculator()

def test_add():
    assert calc.add(2, 3) == 5
    assert calc.add(-1, 1) == 0
    assert calc.add(0, 0) == 0
    print("test_add: OK")

def test_subtract():
    assert calc.subtract(5, 3) == 2
    assert calc.subtract(0, 5) == -5
    print("test_subtract: OK")

def test_multiply():
    assert calc.multiply(4, 5) == 20
    assert calc.multiply(-2, 3) == -6
    print("test_multiply: OK")

def test_divide():
    assert calc.divide(10, 2) == 5
    assert calc.divide(7, 2) == 3.5
    try:
        calc.divide(1, 0)
        assert False, "Должно было выброситься исключение"
    except ValueError:
        pass
    print("test_divide: OK")

def test_power():
    assert calc.power(2, 10) == 1024
    assert calc.power(3, 0) == 1
    print("test_power: OK")

if __name__ == "__main__":
    test_add()
    test_subtract()
    test_multiply()
    test_divide()
    test_power()
    print("Все тесты прошли!")
PYEOF

python3 test_calculator.py
```{{execute}}

## 4. Напишите `.gitlab-ci.yml`

Требования:
- Stages: `validate`, `test`, `build`, `package`
- Job `syntax-check` (stage: validate): `python3 -m py_compile calculator.py`
- Job `unit-tests` (stage: test): `python3 test_calculator.py` + `after_script` с итогом
- Job `build` (stage: build): создаёт `dist/` с `calculator.py` и `info.txt`, сохраняет через `artifacts:`
- Job `create-package` (stage: package): использует артефакты из build, создаёт `package.tar.gz`
- Глобальная переменная `APP_NAME: calculator`

```bash
cat > .gitlab-ci.yml << 'GLCI'
stages:
  - validate
  - test
  - build
  - package

variables:
  APP_NAME: "calculator"
  APP_VERSION: "1.0.0"

syntax-check:
  stage: validate
  script:
    - echo "Проверяем синтаксис $APP_NAME..."
    - python3 -m py_compile calculator.py
    - python3 -m py_compile test_calculator.py
    - echo "Синтаксис OK"

unit-tests:
  stage: test
  script:
    - echo "Запускаем тесты $APP_NAME..."
    - python3 test_calculator.py
  after_script:
    - echo "Тестирование завершено: $APP_NAME v$APP_VERSION"

build:
  stage: build
  script:
    - echo "Собираем $APP_NAME..."
    - mkdir -p dist
    - cp calculator.py dist/
    - echo "app=$APP_NAME" > dist/info.txt
    - echo "version=$APP_VERSION" >> dist/info.txt
    - echo "built_at=$(date -u)" >> dist/info.txt
    - ls -la dist/
  artifacts:
    paths: [dist/]
    expire_in: 1 hour

create-package:
  stage: package
  needs: [build]
  script:
    - echo "Создаём пакет..."
    - cat dist/info.txt
    - tar -czf package.tar.gz dist/
    - ls -lh package.tar.gz
    - echo "Пакет создан!"
  artifacts:
    paths: [package.tar.gz]
    expire_in: 1 hour
GLCI
```{{execute}}

## 5. Проверьте YAML и запустите все jobs

```bash
python3 -c "import yaml; yaml.safe_load(open('.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}

```bash
echo "=== Job: syntax-check ===" && gitlab-runner exec shell syntax-check 2>&1
```{{execute}}

```bash
echo "=== Job: unit-tests ===" && gitlab-runner exec shell unit-tests 2>&1
```{{execute}}

```bash
echo "=== Job: build ===" && gitlab-runner exec shell build 2>&1
```{{execute}}

```bash
echo "=== Job: create-package ===" && gitlab-runner exec shell create-package 2>&1
```{{execute}}

## 6. Проверьте артефакты

```bash
ls -la dist/ package.tar.gz 2>/dev/null && cat dist/info.txt
```{{execute}}
