# Шаг 7: State Locking — защита от concurrent apply

## Проблема: два apply одновременно

```bash
cat << 'EOF'
Представь: два разработчика запускают terraform apply одновременно.

  Разработчик А:             Разработчик Б:
  terraform plan             terraform plan
  (одобрено)                 (одобрено)
  terraform apply       ->   terraform apply
    читает state              читает СТАРЫЙ state (А ещё не записал)
    создаёт ресурсы           создаёт ТЕ ЖЕ ресурсы
    записывает state          перезаписывает state А
  КОНФЛИКТ! State повреждён, ресурсы созданы дважды или потеряны.

Решение: State Locking
  При apply Terraform захватывает эксклюзивную блокировку.
  Второй apply ждёт или падает с ошибкой.
EOF
```{{execute}}

## Lock файл для локального state

```bash
cd ~/tf-state
```{{execute}}

```bash
cat << 'EOF'
Локальный state (.terraform.lock.hcl НЕ для state locking!):

  Для ЛОКАЛЬНОГО state Terraform использует файловую блокировку ОС.
  .terraform.lock.hcl — это lock для ВЕРСИЙ ПРОВАЙДЕРОВ, не для state.

  Настоящий state locking работает с remote backends:
    S3 + DynamoDB         <- официальный способ для AWS
    Yandex Object Storage <- поддерживает встроенный locking
    Terraform Cloud       <- встроенный locking
    GCS                   <- встроенный locking
    Azure Blob Storage    <- встроенный locking
    PostgreSQL backend    <- locking через транзакции
EOF
```{{execute}}

## Симулируем конфликт lock

```bash
# Создаём lock вручную (как это делает remote backend)
cat terraform.tfstate | jq '.serial'
```{{execute}}

```bash
# -lock=false отключает locking (ОПАСНО в production!)
terraform apply -auto-approve -lock=false
```{{execute}}

```bash
# -lock-timeout: ждать освобождения lock N секунд
terraform plan -lock-timeout=30s 2>&1 | head -5
```{{execute}}

```bash
cat << 'EOF'
Что делать если apply упал и lock не снялся:

  Ошибка: Error locking state: Error acquiring the state lock

  1. Найти кто держит lock:
     terraform force-unlock LOCK_ID

  2. Убедиться что никакой другой apply не запущен
  3. terraform force-unlock -force LOCK_ID

  ОСТОРОЖНО: force-unlock только если уверены что другой процесс мёртв!
  Иначе получите повреждённый state.
EOF
```{{execute}}
