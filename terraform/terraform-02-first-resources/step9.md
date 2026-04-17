# Шаг 9: locals — вычисляемые локальные значения

`locals` позволяет создать именованные выражения внутри конфигурации.
Это промежуточные значения, которые не являются переменными (не принимают input).

## Синтаксис locals

```bash
cat << 'EOF'
locals {
  имя = выражение
}

Ссылка: local.имя (без s!)

Зачем нужны:
  - Избежать дублирования сложных выражений
  - Давать понятные имена вычислениям
  - Комбинировать переменные в одно значение
  - Условные значения через тернарный оператор
EOF
```{{execute}}

## Пример: locals для генерации имён ресурсов

```bash
cd ~/tf-resources
cat > variables.tf << 'EOF'
variable "project" {
  type    = string
  default = "cr-it"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "region" {
  type    = string
  default = "ru-central1"
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
locals {
  # Формат имён ресурсов: project-env-resource
  name_prefix = "${var.project}-${var.environment}"

  # Теги для всех ресурсов
  common_tags = {
    project     = var.project
    environment = var.environment
    region      = var.region
    managed_by  = "terraform"
  }

  # Условное значение
  log_level = var.environment == "production" ? "warn" : "debug"

  # Путь к директории
  base_path = "/tmp/tf-locals/${var.project}"
}

resource "local_file" "config" {
  content = <<-CFG
    project     = ${var.project}
    environment = ${var.environment}
    log_level   = ${local.log_level}
    name_prefix = ${local.name_prefix}
  CFG
  filename        = "${local.base_path}/config.ini"
  file_permission = "0644"
}

resource "local_file" "tags" {
  content  = join("\n", [for k, v in local.common_tags : "${k} = ${v}"])
  filename = "${local.base_path}/tags.txt"
}

resource "local_file" "readme" {
  content  = <<-README
    # ${local.name_prefix}

    Окружение: ${var.environment}
    Регион: ${var.region}
  README
  filename = "${local.base_path}/README.md"
}
EOF
```{{execute}}

```bash
terraform apply -auto-approve
cat /tmp/tf-locals/cr-it/config.ini
cat /tmp/tf-locals/cr-it/tags.txt
```{{execute}}

```bash
# Меняем окружение — log_level автоматически станет debug
terraform apply -auto-approve -var="environment=staging"
cat /tmp/tf-locals/cr-it/config.ini
```{{execute}}
