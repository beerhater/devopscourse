# Шаг 3: Сложные типы — object и tuple

## object — структурированный объект

```bash
cd ~/tf-variables
cat > variables.tf << 'EOF'
variable "project_name" {
  type    = string
  default = "cr-it"
}

# object — как struct: каждое поле имеет свой тип
variable "database" {
  type = object({
    host     = string
    port     = number
    name     = string
    ssl      = bool
    max_conn = number
  })
  default = {
    host     = "localhost"
    port     = 5432
    name     = "appdb"
    ssl      = true
    max_conn = 100
  }
}

# list(object) — список объектов (таблица)
variable "services" {
  type = list(object({
    name    = string
    port    = number
    enabled = bool
  }))
  default = [
    { name = "api",     port = 8080, enabled = true  },
    { name = "worker",  port = 8081, enabled = true  },
    { name = "metrics", port = 9090, enabled = false },
  ]
}

# object с опциональными полями (Terraform >= 1.3)
variable "app_config" {
  type = object({
    name        = string
    port        = number
    debug       = optional(bool, false)
    log_level   = optional(string, "info")
    max_workers = optional(number, 4)
  })
  default = {
    name = "myapp"
    port = 8080
    # debug, log_level, max_workers — используют default значения
  }
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
# Обращение к полям object
resource "local_file" "db_config" {
  content = <<-CFG
    [database]
    host     = ${var.database.host}
    port     = ${var.database.port}
    name     = ${var.database.name}
    ssl      = ${var.database.ssl}
    max_conn = ${var.database.max_conn}
  CFG
  filename = "/tmp/tf-vars/db.conf"
}

# Итерация по list(object)
resource "local_file" "services_config" {
  content = join("
", [
    for svc in var.services :
    "${svc.name}:${svc.port} (enabled=${svc.enabled})"
  ])
  filename = "/tmp/tf-vars/services.txt"
}

# optional поля
resource "local_file" "app_config" {
  content = <<-CFG
    name        = ${var.app_config.name}
    port        = ${var.app_config.port}
    debug       = ${var.app_config.debug}
    log_level   = ${var.app_config.log_level}
    max_workers = ${var.app_config.max_workers}
  CFG
  filename = "/tmp/tf-vars/app.conf"
}
EOF
terraform apply -auto-approve
```{{execute}}

```bash
cat /tmp/tf-vars/db.conf
echo "---"
cat /tmp/tf-vars/services.txt
echo "---"
cat /tmp/tf-vars/app.conf
```{{execute}}
