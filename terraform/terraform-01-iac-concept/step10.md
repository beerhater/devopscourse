# Шаг 10: Итоговое задание — пишем первый проект

Создайте Terraform-проект с нуля, применив всё изученное.

## Задание

Создайте проект, который генерирует структуру файлов конфигурации приложения.

## 1. Создаём проект

```bash
mkdir -p ~/terraform-final && cd ~/terraform-final
```{{execute}}

## 2. providers.tf

```bash
cat > providers.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}
EOF
```{{execute}}

## 3. variables.tf

```bash
cat > variables.tf << 'EOF'
variable "app_name" {
  description = "Название приложения"
  type        = string
  default     = "cr-it-app"
}

variable "environment" {
  description = "Окружение деплоя"
  type        = string
  default     = "production"
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Допустимые значения: dev, staging, production."
  }
}

variable "app_port" {
  description = "Порт приложения"
  type        = number
  default     = 8080
}

variable "base_dir" {
  description = "Базовая директория"
  type        = string
  default     = "/tmp/app-config"
}
EOF
```{{execute}}

## 4. main.tf

```bash
cat > main.tf << 'EOF'
resource "random_id" "deploy_id" {
  byte_length = 6
}

# Директория конфигурации
resource "local_file" "app_config" {
  content = <<-CONFIG
    [application]
    name        = ${var.app_name}
    environment = ${var.environment}
    port        = ${var.app_port}
    deploy_id   = ${random_id.deploy_id.hex}

    [logging]
    level = ${var.environment == "production" ? "warn" : "debug"}
    path  = /var/log/${var.app_name}.log
  CONFIG
  filename        = "${var.base_dir}/${var.app_name}.conf"
  file_permission = "0644"
}

resource "local_file" "env_file" {
  content = <<-ENV
    APP_NAME=${var.app_name}
    APP_ENV=${var.environment}
    APP_PORT=${var.app_port}
    DEPLOY_ID=${random_id.deploy_id.hex}
  ENV
  filename        = "${var.base_dir}/.env"
  file_permission = "0600"
}

resource "local_file" "readme" {
  content  = "# ${var.app_name}

Окружение: **${var.environment}**
Порт: ${var.app_port}
Deploy ID: ${random_id.deploy_id.hex}
"
  filename = "${var.base_dir}/README.md"
}
EOF
```{{execute}}

## 5. outputs.tf

```bash
cat > outputs.tf << 'EOF'
output "deploy_id" {
  description = "Уникальный ID деплоя"
  value       = random_id.deploy_id.hex
}

output "config_path" {
  description = "Путь к конфигу"
  value       = local_file.app_config.filename
}

output "env_summary" {
  description = "Сводка окружения"
  value       = "${var.app_name} в ${var.environment} на порту ${var.app_port}"
}
EOF
```{{execute}}

## 6. Инициализация и применение

```bash
terraform init
```{{execute}}

```bash
terraform fmt && terraform validate
```{{execute}}

```bash
terraform plan
```{{execute}}

```bash
terraform apply -auto-approve
```{{execute}}

## 7. Проверяем результат

```bash
cat /tmp/app-config/cr-it-app.conf
```{{execute}}

```bash
cat /tmp/app-config/.env
```{{execute}}

```bash
# outputs
terraform output
```{{execute}}

## 8. Меняем переменные через -var

```bash
terraform apply -auto-approve   -var="environment=staging"   -var="app_port=3000"
```{{execute}}

```bash
cat /tmp/app-config/cr-it-app.conf
```{{execute}}

```bash
# Убираем за собой
terraform destroy -auto-approve
```{{execute}}
