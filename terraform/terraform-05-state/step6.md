# Шаг 6: Sensitive данные в state — проблема безопасности

## Пароли хранятся в ОТКРЫТОМ ВИДЕ

```bash
cd ~/tf-state
```{{execute}}

```bash
# Смотрим random_password в state
cat terraform.tfstate | jq '.resources[] | select(.type == "random_password") | .instances[].attributes.result'
```{{execute}}

```bash
# Содержимое local_sensitive_file тоже видно
cat terraform.tfstate | jq '.resources[] | select(.type == "local_file") | .instances[].attributes.content'
```{{execute}}

```bash
cat << 'EOF'
ВАЖНО: sensitive = true НЕ шифрует данные в state!

  sensitive = true в variable/output:
    - Скрывает значение в terraform plan/apply выводе
    - Скрывает в terraform show
    - НО в terraform.tfstate данные хранятся PLAINTEXT

  Это означает:
    ❌ Нельзя коммитить terraform.tfstate в git
    ❌ Нельзя хранить state в незашифрованном S3 без политик доступа
    ✅ S3 с SSE (Server-Side Encryption) + IAM политики
    ✅ Terraform Cloud / HCP Terraform (шифрует state)
    ✅ Yandex Object Storage с шифрованием
EOF
```{{execute}}

## Что попадает в state

```bash
cat << 'EOF'
В state хранится ВСЁ что возвращает провайдер:

  random_password     <- plaintext пароль
  tls_private_key     <- приватный ключ
  aws_secretsmanager  <- ARN секрета (не само значение)
  aws_rds_instance    <- пароль БД если передан в конфиг
  kubernetes_secret   <- base64 закодированные данные

Типичные чувствительные данные в state:
  - Пароли баз данных
  - API ключи и токены
  - TLS приватные ключи
  - SSH ключи
  - Service account credentials

Защита state:
  1. Remote backend с шифрованием (S3 SSE-S3 или SSE-KMS)
  2. Ограниченный доступ (IAM/ACL)
  3. State locking (предотвращает concurrent write)
  4. Версионирование (возможность отката)
  5. Никогда не коммитить в git!
EOF
```{{execute}}

## .gitignore для state

```bash
cat > ~/tf-state/.gitignore << 'EOF'
# State файлы — могут содержать секреты
terraform.tfstate
terraform.tfstate.backup
*.tfstate
*.tfstate.*

# Бинарные планы
*.tfplan
tfplan

# Директория провайдеров
.terraform/

# Файлы с секретами
*.tfvars
!example.tfvars

# Переопределения (локальные)
override.tf
override.tf.json
*_override.tf
*_override.tf.json
EOF

cat ~/tf-state/.gitignore
```{{execute}}
