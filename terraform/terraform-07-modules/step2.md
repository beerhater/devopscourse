# Шаг 2: Создаём первый локальный модуль

Сделаем модуль `app-config` который генерирует конфиг-файлы приложения.

## Структура проекта

```bash
mkdir -p ~/tf-modules/modules/app-config
mkdir -p ~/tf-modules/modules/app-config/examples/basic
cd ~/tf-modules
```{{execute}}

## modules/app-config/versions.tf

```bash
cat > modules/app-config/versions.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
}
EOF
```{{execute}}

## modules/app-config/variables.tf

```bash
cat > modules/app-config/variables.tf << 'EOF'
variable "project" {
  type        = string
  description = "Название проекта"
  validation {
    condition     = can(regex("^[a-z0-9-]{2,30}$", var.project))
    error_message = "project: строчные буквы, цифры, дефис, 2-30 символов."
  }
}

variable "environment" {
  type        = string
  description = "Окружение: dev, staging, production"
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment: dev | staging | production."
  }
}

variable "app_port" {
  type        = number
  description = "Порт приложения"
  default     = 8080
  validation {
    condition     = var.app_port >= 1024 && var.app_port <= 65535
    error_message = "app_port: 1024-65535."
  }
}

variable "output_dir" {
  type        = string
  description = "Директория для конфигов"
  default     = "/tmp/modules-demo"
}

variable "extra_env_vars" {
  type        = map(string)
  description = "Дополнительные переменные окружения"
  default     = {}
}
EOF
```{{execute}}

## modules/app-config/main.tf

```bash
cat > modules/app-config/main.tf << 'EOF'
locals {
  name      = "${var.project}-${var.environment}"
  log_level = var.environment == "production" ? "warn" : "debug"
  base_dir  = "${var.output_dir}/${var.environment}"

  default_env = {
    APP_PORT  = tostring(var.app_port)
    APP_NAME  = local.name
    LOG_LEVEL = local.log_level
  }
  all_env = merge(local.default_env, var.extra_env_vars)
}

resource "random_id" "deploy_id" {
  byte_length = 6
}

resource "local_file" "app_config" {
  content = <<-CFG
    [app]
    name        = ${local.name}
    environment = ${var.environment}
    port        = ${var.app_port}
    log_level   = ${local.log_level}
    deploy_id   = ${random_id.deploy_id.hex}
  CFG
  filename        = "${local.base_dir}/${var.project}.conf"
  file_permission = "0644"
}

resource "local_file" "env_file" {
  content         = join("\n", [for k, v in local.all_env : "${k}=${v}"])
  filename        = "${local.base_dir}/.env"
  file_permission = "0644"
}
EOF
```{{execute}}

## modules/app-config/outputs.tf

```bash
cat > modules/app-config/outputs.tf << 'EOF'
output "deploy_id" {
  description = "Уникальный ID деплоя"
  value       = random_id.deploy_id.hex
}

output "config_path" {
  description = "Путь к файлу конфигурации"
  value       = local_file.app_config.filename
}

output "env_path" {
  description = "Путь к .env файлу"
  value       = local_file.env_file.filename
}

output "app_name" {
  description = "Полное имя приложения"
  value       = local.name
}
EOF
```{{execute}}

```bash
tree ~/tf-modules/modules/app-config/
```{{execute}}
