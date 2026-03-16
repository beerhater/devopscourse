# Шаг 1: Жизнь без CI/CD — что может пойти не так

Прежде чем строить автоматизацию, важно понять **какую именно проблему** она решает. Давайте воспроизведём типичный ручной процесс деплоя.

## Создайте учебный проект

```bash
mkdir -p /opt/myapp && cd /opt/myapp
```{{execute}}

Создадим простое Python-приложение:

```bash
cat > app.py << 'PYEOF'
import sys

def add(a, b):
    return a + b

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

Запустите приложение:

```bash
python3 app.py
```{{execute}}

## Проблема 1: Ручная проверка

Теперь представьте: вы случайно сломали функцию `add`:

```bash
cat > app.py << 'PYEOF'
import sys

def add(a, b):
    return a - b  # БАГ: опечатка, вычитание вместо сложения!

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

Запустите — приложение **всё равно запускается** и выглядит нормально:

```bash
python3 app.py
```{{execute}}

Результат `add(2, 3) = -1` — явный баг. Но если вы не смотрите внимательно, то задеплоите сломанный код!

## Проблема 2: Ручной деплой — много шагов

Ручной процесс деплоя типично выглядит так:

```bash
# Шаг 1: проверить тесты (если вообще есть)
# python3 -m pytest tests/ ...

# Шаг 2: собрать Docker-образ
# docker build -t myapp:latest .

# Шаг 3: залогиниться в registry
# docker login ...

# Шаг 4: запушить образ
# docker push myapp:latest

# Шаг 5: зайти на сервер по SSH
# ssh user@server

# Шаг 6: на сервере остановить старую версию
# docker stop myapp && docker rm myapp

# Шаг 7: запустить новую
# docker run -d --name myapp myapp:latest

echo "Это 7 шагов которые нужно делать КАЖДЫЙ раз при деплое"
echo "И каждый из них можно сделать неправильно"
```{{execute}}

## Проблема 3: "У меня работает"

Классическая ситуация — разработчик тестирует на своей машине, а на сервере другая версия Python, другие зависимости, другие переменные окружения. CI/CD **стандартизирует окружение**: код всегда собирается и тестируется в одинаковых условиях.

## Вывод

CI/CD решает три проблемы:
- **Пропущенные баги** — тесты запускаются автоматически на каждый коммит
- **Ошибки при деплое** — процесс автоматизирован и воспроизводим
- **"У меня работает"** — сборка в стандартном окружении

Восстановите исходный `app.py`:

```bash
cat > app.py << 'PYEOF'
def add(a, b):
    return a + b

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
python3 app.py
```{{execute}}
