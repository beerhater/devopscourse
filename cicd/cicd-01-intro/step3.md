# Шаг 3: Первый пайплайн на bash

Лучший способ понять CI/CD — написать пайплайн **вручную**. Никакого GitHub Actions, никакого GitLab — только bash. Именно так работают все CI/CD системы под капотом.

## Создайте файл тестов

Сначала нам нужно что тестировать:

```bash
cd /opt/myapp
```{{execute}}

```bash
cat > tests.py << 'PYEOF'
import sys
sys.path.insert(0, '.')
from app import add, multiply, divide

def test_add():
    assert add(2, 3) == 5, f"Ожидалось 5, получили {add(2, 3)}"
    assert add(0, 0) == 0, "add(0, 0) должно быть 0"
    assert add(-1, 1) == 0, "add(-1, 1) должно быть 0"
    print("✅ test_add: OK")

def test_multiply():
    assert multiply(4, 5) == 20, f"Ожидалось 20, получили {multiply(4, 5)}"
    assert multiply(0, 100) == 0, "multiply(0, 100) должно быть 0"
    print("✅ test_multiply: OK")

def test_divide():
    assert divide(10, 2) == 5, f"Ожидалось 5, получили {divide(10, 2)}"
    try:
        divide(1, 0)
        assert False, "Должно было выброситься исключение"
    except ValueError:
        pass
    print("✅ test_divide: OK")

if __name__ == "__main__":
    print("Запускаем тесты...")
    test_add()
    test_multiply()
    test_divide()
    print("")
    print("✅ Все тесты прошли!")
PYEOF
```{{execute}}

Проверьте что тесты работают:

```bash
python3 tests.py
```{{execute}}

## Создайте bash-пайплайн

Теперь напишем настоящий пайплайн:

```bash
cat > pipeline.sh << 'PIPELINE'
#!/bin/bash

# ================================================================
# Простой CI/CD пайплайн на bash
# Имитирует то, что делают GitHub Actions / GitLab CI
# ================================================================

# Цвета для красивого вывода
RED='[0;31m'
GREEN='[0;32m'
YELLOW='[1;33m'
BLUE='[0;34m'
NC='[0m' # No Color

# Счётчики
STEPS_TOTAL=0
STEPS_PASSED=0
STEPS_FAILED=0

# Время начала
PIPELINE_START=$(date +%s)

echo ""
echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}        🚀 CI/CD PIPELINE STARTED               ${NC}"
echo -e "${BLUE}=================================================${NC}"
echo "Start time: $(date)"
echo "Working dir: $(pwd)"
echo ""

# ── Функция выполнения шага ──────────────────────────────────────
run_step() {
    local STEP_NAME="$1"
    local STEP_CMD="$2"

    STEPS_TOTAL=$((STEPS_TOTAL + 1))

    echo -e "${YELLOW}▶ STEP $STEPS_TOTAL: $STEP_NAME${NC}"
    echo "  Command: $STEP_CMD"
    echo "  ---"

    # Запускаем команду, захватываем вывод и код возврата
    STEP_OUTPUT=$(eval "$STEP_CMD" 2>&1)
    STEP_EXIT_CODE=$?

    # Выводим результат с отступом
    echo "$STEP_OUTPUT" | sed 's/^/  /'

    if [ $STEP_EXIT_CODE -eq 0 ]; then
        STEPS_PASSED=$((STEPS_PASSED + 1))
        echo -e "  ${GREEN}✅ PASSED${NC}"
    else
        STEPS_FAILED=$((STEPS_FAILED + 1))
        echo -e "  ${RED}❌ FAILED (exit code: $STEP_EXIT_CODE)${NC}"
        echo ""
        echo -e "${RED}Pipeline FAILED at step: $STEP_NAME${NC}"
        echo -e "${RED}Stopping pipeline. No deploy will happen.${NC}"
        print_summary
        exit 1
    fi
    echo ""
}

# ── Функция итогов ───────────────────────────────────────────────
print_summary() {
    PIPELINE_END=$(date +%s)
    DURATION=$((PIPELINE_END - PIPELINE_START))

    echo -e "${BLUE}=================================================${NC}"
    echo -e "${BLUE}              PIPELINE SUMMARY                  ${NC}"
    echo -e "${BLUE}=================================================${NC}"
    echo "  Total steps:  $STEPS_TOTAL"
    echo -e "  Passed:       ${GREEN}$STEPS_PASSED${NC}"
    echo -e "  Failed:       ${RED}$STEPS_FAILED${NC}"
    echo "  Duration:     ${DURATION}s"
    echo ""
}

# ================================================================
# STAGE 1: BUILD
# ================================================================
echo -e "${BLUE}━━━ STAGE: BUILD ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

run_step "Check Python version" "python3 --version"
run_step "Check app syntax" "python3 -m py_compile app.py && echo 'Syntax OK'"
run_step "Run app" "python3 app.py"

# ================================================================
# STAGE 2: TEST
# ================================================================
echo -e "${BLUE}━━━ STAGE: TEST ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

run_step "Run unit tests" "python3 tests.py"

# ================================================================
# STAGE 3: PACKAGE
# ================================================================
echo -e "${BLUE}━━━ STAGE: PACKAGE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

run_step "Create package" "tar czf app-package.tar.gz app.py && echo 'Package created: app-package.tar.gz'"
run_step "Verify package" "tar tzf app-package.tar.gz && echo 'Package is valid'"

# ================================================================
# STAGE 4: DEPLOY (симуляция)
# ================================================================
echo -e "${BLUE}━━━ STAGE: DEPLOY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

run_step "Deploy to production" "mkdir -p /tmp/production && cp app-package.tar.gz /tmp/production/ && echo 'Deployed to /tmp/production'"

# ================================================================
# ИТОГ
# ================================================================
print_summary

echo -e "${GREEN}🎉 Pipeline completed successfully!${NC}"
echo -e "${GREEN}   Application deployed to /tmp/production${NC}"
PIPELINE
chmod +x pipeline.sh
```{{execute}}

## Запустите пайплайн

```bash
bash pipeline.sh
```{{execute}}

Обратите внимание на структуру вывода — это то же самое что вы видите в интерфейсе GitHub Actions или GitLab CI, только там это происходит автоматически при `git push`.

## Посмотрите что создал пайплайн

```bash
ls -la /tmp/production/
```{{execute}}
