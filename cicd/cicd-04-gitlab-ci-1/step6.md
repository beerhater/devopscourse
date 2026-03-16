# Шаг 6: Запускаем GitLab Runner локально

## Два способа локального запуска

**Способ 1: `gitlab-runner exec shell`** — запускает отдельный job прямо в shell, без Docker. Быстро, просто, не требует регистрации.

**Способ 2: GitLab в Docker** — полноценный GitLab-сервер + Runner, но требует 4GB RAM и 10+ минут на старт. На Killercoda не подходит.

Мы используем **`gitlab-runner exec shell`** — он идеален для обучения.

## Устанавливаем GitLab Runner

```bash
# Проверяем есть ли уже
gitlab-runner --version 2>/dev/null || true
```{{execute}}

```bash
# Устанавливаем если нет
if ! which gitlab-runner > /dev/null 2>&1; then
  curl -L --output /usr/local/bin/gitlab-runner     "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64" 2>/dev/null ||   wget -qO /usr/local/bin/gitlab-runner     "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
  chmod +x /usr/local/bin/gitlab-runner
fi
gitlab-runner --version
```{{execute}}

## Создаём приложение для запуска

```bash
cd /opt/gitlab-ci-demo
```{{execute}}

```bash
cat > app.py << 'PYEOF'
import os

APP_VERSION = os.environ.get("APP_VERSION", "dev")

def greet(name):
    return f"Hello, {name}! (v{APP_VERSION})"

def add(a, b):
    return a + b

def is_palindrome(s):
    s = s.lower().replace(" ", "")
    return s == s[::-1]

if __name__ == "__main__":
    print(greet("GitLab CI"))
    print(f"2 + 3 = {add(2, 3)}")
    print(f"'racecar' palindrome: {is_palindrome('racecar')}")
PYEOF

cat > tests.py << 'PYEOF'
from app import greet, add, is_palindrome
import os

def test_greet():
    result = greet("World")
    assert "Hello" in result
    assert "World" in result
    print("test_greet: OK")

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0
    print("test_add: OK")

def test_palindrome():
    assert is_palindrome("racecar") == True
    assert is_palindrome("hello") == False
    assert is_palindrome("A man a plan a canal Panama") == True
    print("test_palindrome: OK")

if __name__ == "__main__":
    test_greet()
    test_add()
    test_palindrome()
    print("Все тесты прошли!")
PYEOF

python3 tests.py
```{{execute}}

## Основной .gitlab-ci.yml для запуска

```bash
cat > .gitlab-ci.yml << 'GLCI'
stages:
  - lint
  - test
  - build

variables:
  APP_VERSION: "1.0.0"
  BUILD_DIR: "dist"

# ─── Stage: lint ──────────────────────────────────────────────
check-syntax:
  stage: lint
  script:
    - echo ">>> Проверяем синтаксис Python..."
    - python3 -m py_compile app.py
    - python3 -m py_compile tests.py
    - echo ">>> Синтаксис OK"

# ─── Stage: test ──────────────────────────────────────────────
unit-tests:
  stage: test
  script:
    - echo ">>> Запускаем тесты..."
    - python3 tests.py
  after_script:
    - echo ">>> Тесты завершены"

# ─── Stage: build ─────────────────────────────────────────────
build-package:
  stage: build
  script:
    - echo ">>> Сборка пакета v$APP_VERSION..."
    - mkdir -p $BUILD_DIR
    - cp app.py $BUILD_DIR/
    - echo "version=$APP_VERSION" > $BUILD_DIR/info.txt
    - echo "sha=localrun" >> $BUILD_DIR/info.txt
    - echo ">>> Сборка завершена:"
    - ls -la $BUILD_DIR/
  artifacts:
    paths:
      - dist/
    expire_in: 1 hour
GLCI
```{{execute}}

## Запускаем jobs через gitlab-runner exec

```bash
echo "=== Запуск job: check-syntax ==="
gitlab-runner exec shell check-syntax 2>&1
```{{execute}}

```bash
echo "=== Запуск job: unit-tests ==="
gitlab-runner exec shell unit-tests 2>&1
```{{execute}}

```bash
echo "=== Запуск job: build-package ==="
gitlab-runner exec shell build-package 2>&1
```{{execute}}

## Симулируем падение

```bash
cat > .gitlab-ci.fail.yml << 'GLCI'
stages: [test]

failing-test:
  stage: test
  script:
    - echo "Шаг 1: OK"
    - python3 -c "assert 1 == 2, 'Тест провалился!'"
    - echo "Шаг 3: не выполнится"
GLCI

gitlab-runner exec shell failing-test --config /dev/null 2>&1 || echo "Job упал (ожидаемо)"
```{{execute}}

## Просмотр доступных jobs

```bash
python3 << 'PYEOF'
import yaml

ci = yaml.safe_load(open("/opt/gitlab-ci-demo/.gitlab-ci.yml"))
stages = ci.get("stages", [])
print(f"Stages: {stages}")
print()
for name, job in ci.items():
    if isinstance(job, dict) and "stage" in job:
        print(f"  Job: {name:20} stage: {job['stage']}")
PYEOF
```{{execute}}
