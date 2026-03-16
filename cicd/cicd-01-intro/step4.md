# Шаг 4: Добавляем тесты — пайплайн останавливается при ошибке

Главная ценность CI/CD — **пайплайн не даёт сломанному коду попасть на production**. Давайте убедимся в этом на практике.

## Сломайте код и запустите пайплайн

```bash
cd /opt/myapp
```{{execute}}

Введём баг в `app.py`:

```bash
cat > app.py << 'PYEOF'
def add(a, b):
    return a - b  # БАГ: опечатка!

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError("Деление на ноль!")
    return a / b

if __name__ == "__main__":
    print(f"add(2, 3) = {add(2, 3)}")
    print(f"multiply(4, 5) = {multiply(4, 5)}")
    print(f"divide(10, 2) = {divide(10, 2)}")
    print("Приложение работает!")
PYEOF
```{{execute}}

Запустите пайплайн:

```bash
bash pipeline.sh
```{{execute}}

**Пайплайн остановился на стадии TEST!** Deploy не произошёл. Код с багом не попал на production — именно это и нужно.

## Убедитесь что деплоя не было

Посмотрите время изменения файла в production — оно должно остаться от предыдущего запуска:

```bash
ls -la /tmp/production/
```{{execute}}

## Исправьте баг и снова запустите

```bash
cat > app.py << 'PYEOF'
def add(a, b):
    return a + b  # Исправлено!

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError("Деление на ноль!")
    return a / b

if __name__ == "__main__":
    print(f"add(2, 3) = {add(2, 3)}")
    print(f"multiply(4, 5) = {multiply(4, 5)}")
    print(f"divide(10, 2) = {divide(10, 2)}")
    print("Приложение работает!")
PYEOF
```{{execute}}

```bash
bash pipeline.sh
```{{execute}}

Теперь всё зелёное — деплой прошёл.

## Добавьте линтинг в пайплайн

Реальные пайплайны также проверяют стиль кода. Добавим проверку синтаксиса:

```bash
cat > lint.sh << 'SCRIPT'
#!/bin/bash
echo "Проверяем стиль кода..."

# Проверяем что нет табуляций (PEP8 требует пробелы)
if grep -P "^\t" app.py; then
    echo "❌ Найдены табуляции! Используйте пробелы."
    exit 1
fi

# Проверяем что файл не пустой
if [ ! -s app.py ]; then
    echo "❌ app.py пустой!"
    exit 1
fi

# Проверяем синтаксис Python
python3 -m py_compile app.py
echo "✅ Синтаксис корректный"

echo "✅ Линтинг пройден!"
SCRIPT
chmod +x lint.sh
bash lint.sh
```{{execute}}

## Добавьте отчёт о тестах

```bash
cat > test-with-report.sh << 'SCRIPT'
#!/bin/bash

REPORT_FILE="/tmp/test-report-$(date +%Y%m%d-%H%M%S).txt"
echo "Test Report - $(date)" > "$REPORT_FILE"
echo "==============================" >> "$REPORT_FILE"

python3 tests.py 2>&1 | tee -a "$REPORT_FILE"
EXIT_CODE=${PIPESTATUS[0]}

echo "" >> "$REPORT_FILE"
echo "Exit code: $EXIT_CODE" >> "$REPORT_FILE"

echo ""
echo "Отчёт сохранён: $REPORT_FILE"
cat "$REPORT_FILE"

exit $EXIT_CODE
SCRIPT
chmod +x test-with-report.sh
bash test-with-report.sh
```{{execute}}
