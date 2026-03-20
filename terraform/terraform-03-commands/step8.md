# Шаг 8: terraform output и terraform console

## terraform output

```bash
cd ~/tf-commands
```{{execute}}

```bash
# Показать все outputs
terraform output
```{{execute}}

```bash
# Конкретный output
terraform output config_path
```{{execute}}

```bash
# В JSON (для скриптов)
terraform output -json
```{{execute}}

```bash
# Использование в bash скриптах
CONFIG_PATH=$(terraform output -raw config_path)
echo "Конфиг находится: $CONFIG_PATH"
cat "$CONFIG_PATH"
```{{execute}}

```bash
cat << 'EOF'
Флаги terraform output:
  -json         JSON формат всех outputs
  -raw          сырое значение без кавычек (для bash)
  -no-color     без цвета
  [имя]         конкретный output

Типичный use case:
  # В CI/CD после terraform apply
  DB_HOST=$(terraform output -raw database_host)
  APP_URL=$(terraform output -raw app_url)
  curl -f "$APP_URL/healthz" || exit 1
EOF
```{{execute}}

## terraform console — интерактивная консоль

```bash
cat << 'EOF'
terraform console — REPL для вычисления HCL выражений.

  Использует текущий state и конфигурацию.
  Удобно для:
    - Проверки выражений перед вставкой в .tf
    - Изучения функций HCL
    - Отладки сложных выражений
EOF
```{{execute}}

```bash
# Запускаем console и проверяем выражения
terraform console << 'HEREDOC'
"hello world"
upper("hello")
length("terraform")
max(5, 12, 9)
format("%s-%s", "cr-it", "prod")
toset(["a", "b", "a", "c"])
jsonencode({name = "test", port = 8080})
HEREDOC
```{{execute}}

```bash
# Работаем с переменными и ресурсами из state
terraform console << 'HEREDOC'
var.env
var.name
local_file.config.filename
random_id.id.hex
"prefix-${random_id.id.hex}"
HEREDOC
```{{execute}}

```bash
# Полезные функции для проверки
terraform console << 'HEREDOC'
trimspace("  hello  ")
split(",", "a,b,c")
join("-", ["one", "two", "three"])
replace("hello world", " ", "-")
substr("terraform", 0, 5)
HEREDOC
```{{execute}}
