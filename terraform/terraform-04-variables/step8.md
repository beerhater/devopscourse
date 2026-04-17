# Шаг 8: for выражения и функции над коллекциями

HCL поддерживает `for` выражения для преобразования коллекций.

## Синтаксис for

```bash
cat << 'EOF'
LIST to LIST:
  [for item in var.list : ВЫРАЖЕНИЕ]
  [for item in var.list : ВЫРАЖЕНИЕ if УСЛОВИЕ]

LIST to MAP:
  {for item in var.list : item.key => item.value}

MAP to LIST:
  [for k, v in var.map : "${k}=${v}"]

MAP to MAP:
  {for k, v in var.map : k => upper(v)}
EOF
```{{execute}}

```bash
cd ~/tf-variables
cat > variables.tf << 'EOF'
variable "project_name" { type = string; default = "cr-it" }

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
    { name = "admin",   port = 9001, enabled = false },
  ]
}

variable "env_config" {
  type = map(string)
  default = {
    LOG_LEVEL = "info"
    DB_HOST   = "localhost"
    CACHE_URL = "redis://localhost"
  }
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
locals {
  # Только включённые сервисы
  enabled_services = [for svc in var.services : svc if svc.enabled]

  # Map: имя -> порт
  service_ports = {for svc in var.services : svc.name => svc.port}

  # ENV строки из map
  env_lines = [for k, v in var.env_config : "${k}=${v}"]
}

resource "local_file" "enabled_services" {
  content  = join("\n", [for svc in local.enabled_services : "${svc.name}:${svc.port}"])
  filename = "/tmp/tf-for/enabled.txt"
}

resource "local_file" "port_map" {
  content  = join("\n", [for name, port in local.service_ports : "${name} -> ${port}"])
  filename = "/tmp/tf-for/ports.txt"
}

resource "local_file" "env_file" {
  content  = join("\n", local.env_lines)
  filename = "/tmp/tf-for/.env"
}

# Создаём файл для каждого включённого сервиса
resource "local_file" "service_configs" {
  for_each = {for svc in local.enabled_services : svc.name => svc}

  content = <<-CFG
    name=${each.value.name}
    port=${each.value.port}
  CFG
  filename = "/tmp/tf-for/${each.key}.conf"
}
EOF
terraform apply -auto-approve
```{{execute}}

```bash
echo "--- enabled.txt ---"
cat /tmp/tf-for/enabled.txt
echo "--- ports.txt ---"
cat /tmp/tf-for/ports.txt
echo "--- .env ---"
cat /tmp/tf-for/.env
echo "--- конфиги сервисов ---"
ls /tmp/tf-for/*.conf
```{{execute}}
