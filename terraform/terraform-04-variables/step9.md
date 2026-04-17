# Шаг 9: locals vs variable — когда что использовать

## Сравнение

```bash
cat << 'EOF'
variable {}                      locals {}
─────────────────────────────    ────────────────────────────────────
Принимает значения снаружи       Вычисляет внутри конфига
Задаётся через -var, tfvars,     Не может быть переопределён снаружи
  TF_VAR_*, default
Это ВХОДНЫЕ параметры            Это ВЫЧИСЛЕННЫЕ промежуточные значения
Используй для: конфигурации,     Используй для: имён ресурсов,
  среды, секретов, портов          тегов, условий, сложных выражений

Ссылка: var.имя                  Ссылка: local.имя (без s!)
EOF
```{{execute}}

## Практика: паттерн naming convention

```bash
cd ~/tf-variables
cat > variables.tf << 'EOF'
variable "project"     { type = string; default = "cr-it" }
variable "environment" { type = string; default = "production" }
variable "region"      { type = string; default = "ru-central1" }
variable "app_port"    { type = number; default = 8080 }
variable "replicas"    { type = number; default = 3 }
EOF
```{{execute}}

```bash
cat > locals.tf << 'EOF'
locals {
  # Стандартный префикс для всех ресурсов
  name_prefix = "${var.project}-${var.environment}"

  # Теги — применяются ко всем ресурсам
  common_tags = {
    project     = var.project
    environment = var.environment
    region      = var.region
    managed_by  = "terraform"
  }

  # Вычисляемые настройки на основе окружения
  log_level     = var.environment == "production" ? "warn" : "debug"
  is_production = var.environment == "production"

  # Условные настройки
  actual_replicas = local.is_production ? var.replicas : 1

  # Пути
  base_path   = "/tmp/tf-naming/${var.environment}"
  config_path = "${local.base_path}/${local.name_prefix}.conf"
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
resource "local_file" "config" {
  content = <<-CFG
    # ${local.name_prefix}
    log_level = ${local.log_level}
    replicas  = ${local.actual_replicas}
    path      = ${local.config_path}

    [tags]
    ${join("\n    ", [for k, v in local.common_tags : "${k} = ${v}"])}
  CFG
  filename = local.config_path
}
EOF
```{{execute}}

```bash
cat > outputs.tf << 'EOF'
output "name_prefix"   { value = local.name_prefix }
output "config_path"   { value = local_file.config.filename }
output "is_production" { value = local.is_production }
output "replicas"      { value = local.actual_replicas }
EOF
```{{execute}}

```bash
terraform apply -auto-approve
cat /tmp/tf-naming/production/cr-it-production.conf
terraform output
```{{execute}}

```bash
# Для staging — replicas автоматически = 1
terraform apply -auto-approve -var="environment=staging"
terraform output replicas
```{{execute}}
