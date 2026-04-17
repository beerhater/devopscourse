# Шаг 6: output — публикуем результаты

`output` — то что Terraform показывает после apply и отдаёт другим модулям/конфигам.

## Синтаксис output

```bash
cat << 'EOF'
output "имя" {
  value       = выражение     # ОБЯЗАТЕЛЬНЫЙ
  description = "Описание"    # рекомендуется
  sensitive   = true/false    # скрыть значение (default: false)
  depends_on  = [...]         # явная зависимость (редко нужна)
}

Ссылка из другого модуля:
  module.имя_модуля.имя_output
EOF
```{{execute}}

## Создаём outputs.tf

```bash
cd ~/tf-variables
cat > variables.tf << 'EOF'
variable "project_name" { type = string; default = "cr-it" }
variable "environment"  { type = string; default = "dev" }
variable "app_port"     { type = number; default = 8080 }
variable "replicas"     { type = number; default = 1 }
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
resource "random_id" "deploy_id" { byte_length = 6 }

resource "random_password" "db_password" {
  length  = 24
  special = false
}

resource "local_file" "app_config" {
  content = <<-CFG
    project     = ${var.project_name}
    environment = ${var.environment}
    port        = ${var.app_port}
    replicas    = ${var.replicas}
    deploy_id   = ${random_id.deploy_id.hex}
  CFG
  filename        = "/tmp/tf-outputs/${var.project_name}.conf"
  file_permission = "0644"
}

resource "local_sensitive_file" "db_config" {
  content         = "DB_PASSWORD=${random_password.db_password.result}"
  filename        = "/tmp/tf-outputs/.db.env"
  file_permission = "0600"
}
EOF
```{{execute}}

```bash
cat > outputs.tf << 'EOF'
# Простые outputs
output "deploy_id" {
  description = "Уникальный ID деплоя"
  value       = random_id.deploy_id.hex
}

output "config_path" {
  description = "Путь к файлу конфигурации"
  value       = local_file.app_config.filename
}

output "config_hash" {
  description = "MD5 хеш конфига (для проверки изменений)"
  value       = local_file.app_config.content_md5
}

# Составной output — объект
output "app_info" {
  description = "Сводная информация о приложении"
  value = {
    project     = var.project_name
    environment = var.environment
    port        = var.app_port
    deploy_id   = random_id.deploy_id.hex
  }
}

# Sensitive output — скрыт в логах
output "db_password" {
  description = "Пароль базы данных"
  value       = random_password.db_password.result
  sensitive   = true
}
EOF
```{{execute}}

```bash
terraform apply -auto-approve
```{{execute}}

```bash
# Смотрим outputs
terraform output
```{{execute}}

```bash
# Sensitive output скрыт по умолчанию
echo "db_password скрыт: $(terraform output db_password)"
```{{execute}}

```bash
# Получить sensitive значение принудительно
terraform output -raw db_password
```{{execute}}

```bash
# JSON — sensitive тоже виден!
terraform output -json | python3 -m json.tool
```{{execute}}
