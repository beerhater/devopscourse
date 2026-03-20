# Шаг 10: Итоговое задание — полный конфиг-генератор

Создайте проект с богатыми переменными: типы, валидация, for выражения, sensitive outputs.

## Создаём проект

```bash
mkdir -p ~/tf-final-lesson4 && cd ~/tf-final-lesson4
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

## variables.tf — все типы

```bash
cat > variables.tf << 'EOF'
variable "project" {
  type        = string
  description = "Название проекта"
  default     = "cr-it"
  validation {
    condition     = can(regex("^[a-z0-9-]{2,20}$", var.project))
    error_message = "project: строчные буквы, цифры, дефис, 2-20 символов."
  }
}

variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment: dev | staging | production."
  }
}

variable "services" {
  type = list(object({
    name    = string
    port    = number
    enabled = optional(bool, true)
  }))
  default = [
    { name = "api",     port = 8080 },
    { name = "grpc",    port = 9090 },
    { name = "metrics", port = 2112, enabled = false },
  ]
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "dev-password-change-in-prod"
}

variable "base_dir" {
  type    = string
  default = "/tmp/final-cfg"
}
EOF
```{{execute}}

## main.tf

```bash
cat > main.tf << 'EOF'
locals {
  env_prefix       = "${var.project}-${var.environment}"
  is_prod          = var.environment == "production"
  enabled_services = [for s in var.services : s if s.enabled]
  service_ports    = {for s in var.services : s.name => s.port}
}

resource "random_id"       "deploy"  { byte_length = 6 }
resource "random_string"   "app_key" { length = 32; special = false }

resource "local_file" "main_config" {
  content = <<-CFG
    [app]
    name      = ${local.env_prefix}
    deploy_id = ${random_id.deploy.hex}
    log_level = ${local.is_prod ? "warn" : "debug"}

    [services]
    ${join("
    ", [for s in local.enabled_services : "${s.name} = ${s.port}"])}
  CFG
  filename        = "${var.base_dir}/${var.environment}/app.conf"
  file_permission = "0644"
}

resource "local_sensitive_file" "secrets" {
  content = <<-ENV
    APP_KEY=${random_string.app_key.result}
    DB_PASSWORD=${var.db_password}
    DEPLOY_ID=${random_id.deploy.hex}
  ENV
  filename        = "${var.base_dir}/${var.environment}/.env"
  file_permission = "0600"
}

resource "local_file" "service_registry" {
  content  = join("
", [for name, port in local.service_ports : "${name}:${port}"])
  filename = "${var.base_dir}/${var.environment}/services.txt"
}
EOF
```{{execute}}

## outputs.tf

```bash
cat > outputs.tf << 'EOF'
output "deploy_id"       { value = random_id.deploy.hex }
output "enabled_count"   { value = length(local.enabled_services) }
output "service_ports"   { value = local.service_ports }
output "config_path"     { value = local_file.main_config.filename }
output "app_key"         { value = random_string.app_key.result; sensitive = true }
EOF
```{{execute}}

## Запуск

```bash
terraform fmt && terraform validate
terraform apply -auto-approve
```{{execute}}

```bash
cat /tmp/final-cfg/dev/app.conf
echo ""; cat /tmp/final-cfg/dev/services.txt
echo ""; terraform output
```{{execute}}

```bash
# Production с другими переменными
terraform apply -auto-approve   -var="environment=production"   -var="db_password=Pr0d-Ultra-S3cure!"
cat /tmp/final-cfg/production/app.conf
```{{execute}}

```bash
terraform destroy -auto-approve -var="environment=production"
terraform destroy -auto-approve
```{{execute}}
