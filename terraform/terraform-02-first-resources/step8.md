# Шаг 8: lifecycle — управление жизненным циклом

`lifecycle` блок внутри ресурса меняет поведение Terraform при обновлении и удалении.

## Три главных опции lifecycle

```bash
cat << 'EOF'
create_before_destroy = true
  Проблема: по умолчанию Terraform удаляет старый ресурс, потом создаёт новый
  Решение: создать новый ПЕРЕД удалением старого (zero-downtime)
  Пример: EC2 instance — не хотим downtime при пересоздании

prevent_destroy = true
  Защита от случайного `terraform destroy`
  Terraform выдаст ошибку при попытке удалить ресурс
  Пример: база данных в production — нельзя случайно удалить

ignore_changes = [список атрибутов]
  Terraform игнорирует изменения указанных атрибутов
  Пример: тег "last_modified" меняется внешним процессом — не трогать
  ignore_changes = all  <- игнорировать все изменения (редко нужно)
EOF
```{{execute}}

## create_before_destroy

```bash
cd ~/tf-resources
cat > main.tf << 'EOF'
resource "random_id" "version" {
  byte_length  = 4

  lifecycle {
    create_before_destroy = true
    # Сначала создать новую версию, потом удалить старую
  }
}

resource "local_file" "versioned" {
  content  = "Версия: ${random_id.version.hex}"
  filename = "/tmp/tf-lifecycle/current.txt"

  lifecycle {
    create_before_destroy = true
  }
}
EOF
terraform apply -auto-approve
cat /tmp/tf-lifecycle/current.txt
```{{execute}}

## prevent_destroy

```bash
cat > main.tf << 'EOF'
resource "local_file" "critical_config" {
  content  = <<-CONF
    КРИТИЧЕСКИ ВАЖНЫЙ КОНФИГ
    НЕ УДАЛЯТЬ!
  CONF
  filename = "/tmp/tf-lifecycle/critical.conf"

  lifecycle {
    prevent_destroy = true   # terraform destroy завершится с ошибкой
  }
}
EOF
terraform apply -auto-approve
```{{execute}}

```bash
# Попытка destroy — должна упасть с ошибкой
terraform destroy -auto-approve 2>&1 | tail -5
```{{execute}}

## ignore_changes

```bash
cat > main.tf << 'EOF'
resource "random_id" "deploy" {
  byte_length = 4
}

resource "local_file" "deployment" {
  content = <<-EOF
    deploy_id = ${random_id.deploy.hex}
    timestamp = initial
  EOF
  filename = "/tmp/tf-lifecycle/deploy.txt"

  lifecycle {
    ignore_changes = [
      content,   # Terraform не будет обновлять файл если content изменился
    ]
  }
}
EOF
terraform apply -auto-approve
cat /tmp/tf-lifecycle/deploy.txt
```{{execute}}

```bash
# Меняем content вручную — но Terraform его проигнорирует
sed -i 's/timestamp = initial/timestamp = modified/' /tmp/tf-lifecycle/deploy.txt
terraform apply -auto-approve 2>&1 | tail -5
echo "--- Файл НЕ изменился (ignore_changes) ---"
cat /tmp/tf-lifecycle/deploy.txt
```{{execute}}
