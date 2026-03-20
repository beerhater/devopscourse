# Шаг 9: Проблемы локального state — зачем хранить удалённо

## Проблемы локального terraform.tfstate

```bash
cat << 'EOF'
ПРОБЛЕМА 1: Команда не может работать вместе

  Разработчик А создал ресурсы, state у него локально.
  Разработчик Б клонирует репозиторий.
  У Б нет state! Terraform думает что всё нужно создать с нуля.
  Б запускает apply -> ДУБЛИКАТЫ ресурсов или ошибки.

ПРОБЛЕМА 2: State в Git — нарушение безопасности

  terraform.tfstate содержит пароли в plaintext.
  Коммит в git = секреты навсегда в истории.
  Даже приватный репозиторий — не достаточно.
  git log --all -- terraform.tfstate  <- найдут все секреты.

ПРОБЛЕМА 3: Нет locking -> повреждение state

  Два apply одновременно = corrupted state.
  Локальная файловая блокировка работает только на одной машине.

ПРОБЛЕМА 4: Нет версионирования

  Одна резервная копия (tfstate.backup) — не достаточно.
  Нет возможности откатиться на 5 версий назад.

РЕШЕНИЕ: Remote Backend
EOF
```{{execute}}

## Remote Backend — решение всех проблем

```bash
cat << 'EOF'
Remote Backend хранит state удалённо:

  S3 + DynamoDB (AWS):
    - State в S3 (шифрование SSE-KMS)
    - Locking через DynamoDB
    - Версионирование через S3 Versioning

  Yandex Object Storage:
    - State в Object Storage
    - Встроенный locking
    - Шифрование через KMS

  Terraform Cloud / HCP Terraform:
    - State + locking + шифрование
    - UI для просмотра state и истории
    - Бесплатно для небольших команд

  GCS (Google Cloud Storage):
    - Встроенный locking
    - Версионирование

  Что даёт remote backend:
    ✅ Единый state для всей команды
    ✅ Locking при concurrent apply
    ✅ История версий (откат)
    ✅ Шифрование чувствительных данных
    ✅ Разделение state по окружениям
    ✅ Нет секретов в git
EOF
```{{execute}}

## Синтаксис remote backend (S3)

```bash
cat << 'EOF'
# В providers.tf:

terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true             # SSE шифрование
    dynamodb_table = "terraform-lock" # locking
  }
}

# Для Yandex Cloud:
terraform {
  backend "s3" {
    bucket   = "my-state-bucket"
    key      = "terraform.tfstate"
    endpoints = { s3 = "https://storage.yandexcloud.net" }
    region   = "ru-central1"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}

# После изменения backend — переинициализировать:
terraform init -migrate-state
EOF
```{{execute}}

## terraform_remote_state — чтение outputs другого state

```bash
cat << 'EOF'
Паттерн: разбить большую инфраструктуру на несколько state файлов.

  infra/networking/    <- создаёт VPC, subnets
    output "vpc_id"   { value = aws_vpc.main.id }

  infra/database/      <- использует VPC из networking
    data "terraform_remote_state" "networking" {
      backend = "s3"
      config = {
        bucket = "my-state"
        key    = "networking/terraform.tfstate"
      }
    }
    resource "aws_db_subnet_group" "main" {
      subnet_ids = data.terraform_remote_state.networking.outputs.subnet_ids
    }

Так разные команды управляют разными частями инфраструктуры
независимо, но могут использовать outputs друг друга.
EOF
```{{execute}}
