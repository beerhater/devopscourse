# Шаг 8: Структура Terraform-проекта

## Стандартная структура файлов

```bash
cat << 'EOF'
Минимальный проект:
  main.tf            ← основные ресурсы
  variables.tf       ← объявление переменных
  outputs.tf         ← объявление outputs
  terraform.tfvars   ← значения переменных (не в git!)

Более крупный проект:
  main.tf
  variables.tf
  outputs.tf
  providers.tf       ← настройка провайдеров
  locals.tf          ← локальные вычисляемые значения
  data.tf            ← data sources (чтение существующих ресурсов)
  terraform.tfvars
  README.md

Разбитый по компонентам:
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
    ec2/
      ...

НЕТ обязательной структуры — Terraform читает все *.tf файлы в директории.
Структура выше — это соглашение, не требование.
EOF
```{{execute}}

## Создаём правильную структуру

```bash
mkdir -p ~/terraform-project
cd ~/terraform-project
```{{execute}}

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

```bash
cat > variables.tf << 'EOF'
variable "project_name" {
  description = "Название проекта"
  type        = string
  default     = "my-project"
}

variable "environment" {
  description = "Окружение: dev, staging, production"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment должен быть: dev, staging, production."
  }
}

variable "output_dir" {
  description = "Директория для создания файлов"
  type        = string
  default     = "/tmp/terraform-project"
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
resource "random_id" "project_id" {
  byte_length = 4
}

resource "local_file" "config" {
  content = <<-CONFIG
    project  = ${var.project_name}
    env      = ${var.environment}
    id       = ${random_id.project_id.hex}
  CONFIG
  filename        = "${var.output_dir}/config.txt"
  file_permission = "0644"
}

resource "local_file" "readme" {
  content = <<-README
    # ${var.project_name}

    Окружение: ${var.environment}
    ID: ${random_id.project_id.hex}
  README
  filename = "${var.output_dir}/README.md"
}
EOF
```{{execute}}

```bash
cat > outputs.tf << 'EOF'
output "project_id" {
  description = "Уникальный ID проекта"
  value       = random_id.project_id.hex
}

output "config_path" {
  description = "Путь к файлу конфигурации"
  value       = local_file.config.filename
}
EOF
```{{execute}}

```bash
ls -la ~/terraform-project/
```{{execute}}
