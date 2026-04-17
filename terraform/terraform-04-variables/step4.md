# Шаг 4: Валидация переменных

`validation` блок позволяет проверять значения переменных до применения конфига.
Если условие не выполнено — Terraform остановится с понятной ошибкой.

## Синтаксис валидации

```bash
cat << 'EOF'
variable "имя" {
  type = string

  validation {
    condition     = <bool выражение>
    error_message = "Сообщение об ошибке."
  }
}

Правила:
  - condition должен вернуть true (норма) или false (ошибка)
  - Можно добавить несколько блоков validation
  - В condition доступно только var.имя (не другие переменные)
  - error_message должен заканчиваться точкой
EOF
```{{execute}}

## Примеры валидаций

```bash
cd ~/tf-variables
cat > variables.tf << 'EOF'
variable "project_name" {
  type        = string
  description = "Название проекта: только строчные буквы, цифры, дефис"
  default     = "cr-it"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name: только строчные буквы, цифры и дефис."
  }

  validation {
    condition     = length(var.project_name) >= 2 && length(var.project_name) <= 30
    error_message = "project_name: длина от 2 до 30 символов."
  }
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment: допустимые значения — dev, staging, production."
  }
}

variable "app_port" {
  type    = number
  default = 8080

  validation {
    condition     = var.app_port >= 1024 && var.app_port <= 65535
    error_message = "app_port: должен быть в диапазоне 1024-65535."
  }
}

variable "replicas" {
  type    = number
  default = 1

  validation {
    condition     = var.replicas > 0 && floor(var.replicas) == var.replicas
    error_message = "replicas: должно быть положительным целым числом."
  }
}

variable "allowed_regions" {
  type    = list(string)
  default = ["ru-central1"]

  validation {
    condition = alltrue([
      for r in var.allowed_regions :
      contains(["ru-central1", "eu-west1", "us-east1"], r)
    ])
    error_message = "allowed_regions: допустимые регионы — ru-central1, eu-west1, us-east1."
  }
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
resource "local_file" "validated_config" {
  content = <<-CFG
    project=${var.project_name}
    env=${var.environment}
    port=${var.app_port}
  CFG
  filename = "/tmp/tf-vars/validated.conf"
}
EOF
terraform validate && echo "Конфиг валиден"
```{{execute}}

## Тестируем валидации — ждём ошибки

```bash
# Неверный environment
terraform apply -auto-approve -var="environment=PROD" 2>&1 | grep -A2 'error_message\|Error\|Invalid'
```{{execute}}

```bash
# Неверный порт
terraform apply -auto-approve -var="app_port=80" 2>&1 | grep -A2 'error_message\|Error\|Invalid'
```{{execute}}

```bash
# Неверное название (заглавные буквы)
terraform apply -auto-approve -var="project_name=My_Project" 2>&1 | grep -A2 'error_message\|Error\|Invalid'
```{{execute}}

```bash
# Правильные значения — всё OK
terraform apply -auto-approve
cat /tmp/tf-vars/validated.conf
```{{execute}}
