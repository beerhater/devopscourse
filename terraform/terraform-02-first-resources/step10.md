# Шаг 10: Итоговое задание

Создайте полноценный проект, который использует все изученные концепции:
`local_file`, `local_sensitive_file`, `data`, `random`, `depends_on`, `locals`.

## Задание: генератор конфигурации приложения

```bash
mkdir -p ~/tf-final-lesson2 && cd ~/tf-final-lesson2
```{{execute}}

## providers.tf

```bash
cat > providers.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
}
EOF
terraform init
```{{execute}}

## variables.tf

```bash
cat > variables.tf << 'EOF'
variable "app_name"    { type = string; default = "cr-it" }
variable "environment" { type = string; default = "production" }
variable "app_port"    { type = number; default = 8080 }
variable "output_dir"  { type = string; default = "/tmp/app-gen" }
EOF
```{{execute}}

## main.tf — связываем всё вместе

```bash
cat > main.tf << 'EOF'
locals {
  name_prefix = "${var.app_name}-${var.environment}"
  log_level   = var.environment == "production" ? "warn" : "debug"
  debug_mode  = var.environment != "production"
}

# Генерируем уникальный ID деплоя
resource "random_id" "deploy" {
  byte_length = 6
}

# Генерируем секретный ключ приложения
resource "random_password" "secret_key" {
  length  = 32
  special = false
}

# Читаем hostname системы
data "local_file" "hostname" {
  filename = "/etc/hostname"
}

# Маркер базовой директории
resource "local_file" "base_dir_marker" {
  content  = "created by terraform"
  filename = "${var.output_dir}/.keep"
}

# Основной конфиг
resource "local_file" "app_config" {
  content = <<-CFG
    [application]
    name        = ${local.name_prefix}
    environment = ${var.environment}
    port        = ${var.app_port}
    deploy_id   = ${random_id.deploy.hex}
    host        = ${trimspace(data.local_file.hostname.content)}

    [logging]
    level  = ${local.log_level}
    debug  = ${local.debug_mode}
    path   = ${var.output_dir}/logs/app.log
  CFG
  filename        = "${var.output_dir}/app.conf"
  file_permission = "0644"
  depends_on      = [local_file.base_dir_marker]
}

# Секретный ключ — sensitive файл
resource "local_sensitive_file" "secret_key" {
  content         = random_password.secret_key.result
  filename        = "${var.output_dir}/secret.key"
  file_permission = "0600"
  depends_on      = [local_file.base_dir_marker]
}

# .env файл для приложения
resource "local_sensitive_file" "env_file" {
  content = <<-ENV
    APP_NAME=${local.name_prefix}
    APP_ENV=${var.environment}
    APP_PORT=${var.app_port}
    APP_SECRET=${random_password.secret_key.result}
    DEPLOY_ID=${random_id.deploy.hex}
  ENV
  filename        = "${var.output_dir}/.env"
  file_permission = "0600"
  depends_on      = [local_file.base_dir_marker]
}

# README
resource "local_file" "readme" {
  content  = <<-README
    # ${local.name_prefix}

    Deploy ID: ${random_id.deploy.hex}
    Host:      ${trimspace(data.local_file.hostname.content)}
    Port:      ${var.app_port}
    Env:       ${var.environment}
  README
  filename        = "${var.output_dir}/README.md"
  file_permission = "0644"
  depends_on      = [local_file.base_dir_marker]
}
EOF
```{{execute}}

## outputs.tf

```bash
cat > outputs.tf << 'EOF'
output "deploy_id"   { value = random_id.deploy.hex }
output "config_path" { value = local_file.app_config.filename }
output "host"        { value = trimspace(data.local_file.hostname.content) }
EOF
```{{execute}}

## Запускаем

```bash
terraform apply -auto-approve
```{{execute}}

```bash
ls -la /tmp/app-gen/
echo ""; cat /tmp/app-gen/app.conf
echo ""; cat /tmp/app-gen/README.md
terraform output
```{{execute}}

```bash
# Пересоздаём для staging
terraform apply -auto-approve -var="environment=staging" -var="app_port=3000"
cat /tmp/app-gen/app.conf
```{{execute}}

```bash
terraform destroy -auto-approve
```{{execute}}
