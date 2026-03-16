# Шаг 2: Структура workflow-файла

Workflow-файл — это YAML. Давайте разберём его структуру **поле за полем**.

## Скелет любого workflow

```yaml
name: Название пайплайна      # отображается в GitHub UI

on: [push]                    # триггер(ы)

jobs:                         # список заданий
  имя-job:                    # произвольное имя
    runs-on: ubuntu-latest    # на каком раннере запускать

    steps:                    # список шагов
      - name: Название шага
        run: echo "Привет!"   # команда в shell
```

## Символ `|` в YAML — многострочный текст

```yaml
run: |
  echo "Строка 1"
  echo "Строка 2"
  echo "Строка 3"
```

Без `|` можно написать только одну команду. С `|` — сколько угодно строк.

## `uses` — готовые Actions из маркетплейса

```yaml
- uses: actions/checkout@v4
```

Это самое важное готовое действие — делает `git clone` вашего репозитория на раннер. **Без него у вас не будет файлов кода в рабочей директории.** Почти каждый workflow начинается с этого шага.

Формат: `{владелец}/{репозиторий}@{версия}`

## Создайте первый workflow

```bash
cd /opt/gh-actions-demo
```{{execute}}

```bash
cat > .github/workflows/hello.yml << 'WORKFLOW'
# Название пайплайна — видно в GitHub UI
name: Hello World Pipeline

# Триггер: запускать при каждом push
on: push

# Список заданий
jobs:
  # Job с именем "say-hello"
  say-hello:
    # Тип раннера — стандартная Ubuntu
    runs-on: ubuntu-latest

    steps:
      # Шаг 1: вывести текст
      - name: Print greeting
        run: echo "Привет из GitHub Actions!"

      # Шаг 2: показать информацию о системе
      - name: Show system info
        run: |
          echo "Операционная система:"
          uname -a
          echo "Дата и время:"
          date

      # Шаг 3: создать файл и прочитать его
      - name: Create a file
        run: echo "Создан пайплайном" > result.txt

      - name: Read the file
        run: cat result.txt
WORKFLOW
```{{execute}}

Проверьте синтаксис — YAML чувствителен к отступам:

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/hello.yml')); print('YAML синтаксис OK')"
```{{execute}}
