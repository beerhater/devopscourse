# Шаг 6: Провайдер random — случайные значения

`random` — утилитарный провайдер для генерации случайных значений.
Генерирует значение один раз при создании и не меняет его при повторных apply.

## Ресурсы провайдера random

```bash
cat << 'EOF'
random_id        <- случайный ID в hex, base64, dec форматах
random_string    <- случайная строка с настройкой символов
random_password  <- безопасный пароль (sensitive)
random_integer   <- случайное целое число в диапазоне
random_shuffle   <- перемешать список
random_pet       <- человекочитаемое имя (hungry-frog, brave-swan)
random_uuid      <- UUID v4
EOF
```{{execute}}

## random_id — самый частый

```bash
cd ~/tf-resources
cat > main.tf << 'EOF'
resource "random_id" "example" {
  byte_length = 8    # количество байт = длина hex / 2
}

resource "local_file" "random_demo" {
  content = <<-EOF
    hex:     ${random_id.example.hex}
    dec:     ${random_id.example.dec}
    base64:  ${random_id.example.b64_std}
    base64url: ${random_id.example.b64_url}
  EOF
  filename = "/tmp/tf-random/random_id.txt"
}
EOF
terraform apply -auto-approve
cat /tmp/tf-random/random_id.txt
```{{execute}}

## random_string и random_password

```bash
cat > main.tf << 'EOF'
resource "random_string" "suffix" {
  length  = 8
  upper   = false    # без заглавных
  special = false    # без спецсимволов
  # lower = true (default)
  # numeric = true (default)
}

resource "random_password" "db_pass" {
  length           = 20
  upper            = true
  lower            = true
  numeric          = true
  special          = true
  override_special = "!#$%"   # только эти спецсимволы
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "local_file" "string_demo" {
  content  = "Суффикс: ${random_string.suffix.result}"
  filename = "/tmp/tf-random/string.txt"
}

# Пароль — sensitive, записываем в sensitive файл
resource "local_sensitive_file" "password_file" {
  content         = random_password.db_pass.result
  filename        = "/tmp/tf-random/db.password"
  file_permission = "0600"
}
EOF
terraform apply -auto-approve
cat /tmp/tf-random/string.txt
echo "Пароль создан в /tmp/tf-random/db.password (sensitive)"
```{{execute}}

## random_pet — читаемые имена ресурсов

```bash
cat > main.tf << 'EOF'
resource "random_pet" "server_name" {
  length    = 2       # количество слов
  separator = "-"
  # prefix = "srv"   # можно добавить префикс
}

resource "random_integer" "port" {
  min = 8000
  max = 9000
}

resource "local_file" "server_info" {
  content  = "Сервер: ${random_pet.server_name.id} слушает порт ${random_integer.port.result}"
  filename = "/tmp/tf-random/server.txt"
}
EOF
terraform apply -auto-approve
cat /tmp/tf-random/server.txt
```{{execute}}
