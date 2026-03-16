# Шаг 7: Итоговое задание

Вы узнали что такое CI/CD и построили пайплайн вручную. Теперь закрепите знания — создайте **полный пайплайн для нового приложения** самостоятельно.

## Задание

Вам дано новое приложение. Создайте для него полноценный пайплайн.

**1. Создайте новый проект:**

```bash
mkdir -p /opt/final-project && cd /opt/final-project
```{{execute}}

**2. Создайте приложение `calculator.py`:**

```bash
cat > calculator.py << 'PYEOF'
def celsius_to_fahrenheit(c):
    return c * 9/5 + 32

def fahrenheit_to_celsius(f):
    return (f - 32) * 5/9

def is_palindrome(text):
    cleaned = text.lower().replace(" ", "")
    return cleaned == cleaned[::-1]

if __name__ == "__main__":
    print(f"0°C = {celsius_to_fahrenheit(0)}°F")
    print(f"100°C = {celsius_to_fahrenheit(100)}°F")
    print(f"'racecar' palindrome: {is_palindrome('racecar')}")
    print(f"'hello' palindrome: {is_palindrome('hello')}")
    print("Приложение работает!")
PYEOF
```{{execute}}

**3. Создайте тесты `test_calculator.py`:**

```bash
cat > test_calculator.py << 'PYEOF'
from calculator import celsius_to_fahrenheit, fahrenheit_to_celsius, is_palindrome

def test_celsius_to_fahrenheit():
    assert celsius_to_fahrenheit(0) == 32, "0°C должно быть 32°F"
    assert celsius_to_fahrenheit(100) == 212, "100°C должно быть 212°F"
    print("✅ test_celsius_to_fahrenheit: OK")

def test_fahrenheit_to_celsius():
    assert fahrenheit_to_celsius(32) == 0, "32°F должно быть 0°C"
    assert fahrenheit_to_celsius(212) == 100, "212°F должно быть 100°C"
    print("✅ test_fahrenheit_to_celsius: OK")

def test_is_palindrome():
    assert is_palindrome("racecar") == True
    assert is_palindrome("hello") == False
    assert is_palindrome("A man a plan a canal Panama") == True
    print("✅ test_is_palindrome: OK")

if __name__ == "__main__":
    test_celsius_to_fahrenheit()
    test_fahrenheit_to_celsius()
    test_is_palindrome()
    print("")
    print("✅ Все тесты прошли!")
PYEOF
```{{execute}}

**4. Создайте Dockerfile:**

```bash
cat > Dockerfile << 'DFILE'
FROM python:3.11-alpine
WORKDIR /app
COPY calculator.py .
COPY test_calculator.py .
RUN python3 calculator.py
RUN python3 test_calculator.py
CMD ["python3", "calculator.py"]
DFILE
```{{execute}}

**5. Создайте полный пайплайн `my-pipeline.sh`** со стадиями:
- `BUILD` — проверить синтаксис, запустить приложение
- `TEST` — запустить тесты
- `DOCKER` — собрать образ `calculator:1.0`
- `DEPLOY` — запустить контейнер `calculator-prod`

```bash
cat > my-pipeline.sh << 'PIPELINE'
#!/bin/bash

RED='[0;31m'
GREEN='[0;32m'
YELLOW='[1;33m'
BLUE='[0;34m'
NC='[0m'

fail() { echo -e "${RED}❌ FAILED: $1${NC}"; exit 1; }
ok()   { echo -e "${GREEN}✅ OK: $1${NC}
"; }

echo -e "${BLUE}=== My Pipeline ===${NC}"

# BUILD
echo -e "${YELLOW}▶ BUILD: syntax check${NC}"
python3 -m py_compile calculator.py || fail "Syntax error"
ok "Syntax OK"

echo -e "${YELLOW}▶ BUILD: run app${NC}"
python3 calculator.py || fail "App crashed"
ok "App runs"

# TEST
echo -e "${YELLOW}▶ TEST: unit tests${NC}"
python3 test_calculator.py || fail "Tests failed"
ok "Tests passed"

# DOCKER
echo -e "${YELLOW}▶ DOCKER: build image${NC}"
docker build -t calculator:1.0 . || fail "Docker build failed"
ok "Image built"

echo -e "${YELLOW}▶ DOCKER: test in container${NC}"
docker run --rm calculator:1.0 python3 test_calculator.py || fail "Tests in container failed"
ok "Container tests passed"

# DEPLOY
echo -e "${YELLOW}▶ DEPLOY: start container${NC}"
docker stop calculator-prod 2>/dev/null; docker rm calculator-prod 2>/dev/null
docker run -d --name calculator-prod calculator:1.0 sleep 3600 || fail "Deploy failed"
ok "Deployed"

echo -e "${BLUE}=== Pipeline complete! ===${NC}"
docker ps --filter "name=calculator-prod"
PIPELINE
chmod +x my-pipeline.sh
```{{execute}}

**6. Запустите пайплайн:**

```bash
bash my-pipeline.sh
```{{execute}}

**7. Проверьте результат:**

```bash
docker ps
docker exec calculator-prod python3 calculator.py
```{{execute}}

**8. Проверьте что пайплайн защищает от багов — сломайте код:**

```bash
echo "def celsius_to_fahrenheit(c): return c" >> calculator.py
bash my-pipeline.sh
```{{execute}}

Пайплайн должен остановиться на стадии TEST.

**9. Очистите:**

```bash
docker stop calculator-prod && docker rm calculator-prod
```{{execute}}
