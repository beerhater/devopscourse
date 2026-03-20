# Шаг 4: State Locking в remote backend

## Как работает locking в S3 backend

```bash
cat << 'EOF'
S3 backend locking:

  AWS S3 + DynamoDB:
    - При apply: создаётся запись в DynamoDB таблице
    - Структура: LockID = "bucket/key", Info = {ID, Operation, Who, When}
    - После apply: запись удаляется
    - Второй apply видит запись -> ждёт или падает

  MinIO (без DynamoDB):
    - Нативного locking нет
    - В production AWS обязательно используй DynamoDB!
    - Yandex Object Storage: встроенный locking

  Terraform Cloud / HCP Terraform:
    - Locking встроен, без доп. инфраструктуры

  Что происходит при locked state:
    Error: Error acquiring the state lock
    Lock Info:
      ID:        a3f8...
      Path:      terraform-state/dev/terraform.tfstate
      Operation: OperationTypeApply
      Who:       user@host
      Version:   1.x.x
      Created:   2026-03-20 ...
EOF
```{{execute}}

## Демонстрация: terraform force-unlock

```bash
cd ~/tf-remote
```{{execute}}

```bash
cat << 'EOF'
Сценарий: apply упал в середине выполнения, lock не снялся.

terraform apply  <- запустили
  [применяется]
  [сеть пропала / процесс убили]
  lock НЕ снялся!

terraform apply  <- пробуем снова
  Error: Error acquiring the state lock

Решение:
  1. Убедиться что предыдущий apply точно не работает
  2. terraform force-unlock LOCK_ID
     (LOCK_ID берём из сообщения об ошибке)
  3. Или: terraform force-unlock -force LOCK_ID

ОСТОРОЖНО: force-unlock при живом apply = повреждение state!
EOF
```{{execute}}

```bash
# Применяем что есть для получения актуального state
terraform apply -auto-approve
```{{execute}}

```bash
# -lock=false: отключить locking (только для отладки!)
terraform plan -lock=false
```{{execute}}

```bash
# -lock-timeout: ждать до N секунд
terraform plan -lock-timeout=10s 2>&1 | head -3
```{{execute}}

## DynamoDB для locking (конфиг)

```bash
cat << 'EOF'
# Для AWS — создаём DynamoDB таблицу:
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# И в backend добавляем:
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"  # <- locking
    encrypt        = true
  }
}
EOF
```{{execute}}
