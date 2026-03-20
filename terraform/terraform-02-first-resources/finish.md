# Урок завершён!

## Что изучили

- **`local_file`** -- `content`, `source`, `content_base64`, `file_permission`, вычисляемые атрибуты
- **`local_sensitive_file`** -- секреты скрыты в plan/show/state
- **Ссылки на атрибуты** -- `resource_type.name.attribute`; неявные зависимости
- **Граф зависимостей** -- Terraform строит автоматически по ссылкам
- **`data` sources** -- читают существующие ресурсы без управления ими
- **`random_*`** -- `random_id`, `random_string`, `random_password`, `random_integer`, `random_pet`
- **`depends_on`** -- явные зависимости когда ссылки нет в коде
- **`lifecycle`** -- `create_before_destroy`, `prevent_destroy`, `ignore_changes`
- **`locals`** -- именованные промежуточные выражения; тернарный оператор

## Шпаргалка

```hcl
# Ресурс
resource "local_file" "name" {
  content         = "текст"
  filename        = "/tmp/file.txt"
  file_permission = "0644"
  depends_on      = [other_resource.name]
  lifecycle { prevent_destroy = true }
}

# Data source
data "local_file" "existing" { filename = "/etc/hostname" }
local_result = trimspace(data.local_file.existing.content)

# Locals
locals { prefix = "${var.project}-${var.env}" }
# Использование: local.prefix

# Random
resource "random_id" "id" { byte_length = 6 }
# Атрибуты: .hex .dec .b64_std
```

## Следующий урок

**Урок 3** — Основные команды: `terraform init`, `plan`, `apply`, `destroy` во всех деталях.
Воркспейсы, `terraform.tfvars`, форматирование и валидация.
