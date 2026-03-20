# Урок завершён!

## Что изучили

- **`variable` блок** -- `type`, `default`, `description`, `sensitive`, `nullable`
- **Примитивные типы** -- `string`, `number`, `bool`
- **Коллекции** -- `list()`, `set()`, `map()`, и их комбинации
- **`object({})`** -- структурированные типы; `optional()` поля
- **Валидация** -- `condition` + `error_message`; `can()`, `regex()`, `contains()`
- **tfvars приоритеты** -- `terraform.tfvars`, `*.auto.tfvars`, `-var-file`, `TF_VAR_*`
- **`output` блок** -- `value`, `description`, `sensitive`, `depends_on`
- **Sensitive** -- скрывает в plan/apply; `-raw` и `-json` для чтения
- **`for` выражения** -- list→list, list→map, map→list; фильтрация через `if`
- **`locals` vs `variable`** -- входные параметры vs внутренние вычисления

## Шпаргалка

```hcl
# Переменная с валидацией
variable "env" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev","staging","production"], var.env)
    error_message = "env: dev | staging | production."
  }
}

# Сложный тип
variable "services" {
  type = list(object({
    name    = string
    port    = number
    enabled = optional(bool, true)
  }))
}

# for выражения
locals {
  enabled = [for s in var.services : s if s.enabled]
  ports   = {for s in var.services : s.name => s.port}
}

# Sensitive output
output "secret" { value = var.password; sensitive = true }
```

## Следующий урок

**Урок 5** — State-файл: структура `terraform.tfstate`, зачем хранить удалённо,
drift detection, `terraform refresh`, проблемы concurrent apply.
