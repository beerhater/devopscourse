# Шаг 2: Типы переменных — string, number, bool, list, map

## Примитивные типы

```bash
cat << 'EOF'
ПРИМИТИВНЫЕ ТИПЫ:
  string    строка:  "hello", "production"
  number    число:   42, 3.14, -10
  bool      булево:  true, false

Terraform автоматически конвертирует:
  "42"  ->  number (если ожидается number)
  "true" -> bool
  1     -> bool (1 = true, 0 = false)
EOF
```{{execute}}

## Коллекции: list, set, map

```bash
cd ~/tf-variables
cat > variables.tf << 'EOF'
variable "project_name" {
  type    = string
  default = "cr-it"
}

# list(тип) — упорядоченный список, дубли разрешены
variable "allowed_ips" {
  type        = list(string)
  description = "Список разрешённых IP"
  default     = ["192.168.1.1", "10.0.0.1", "10.0.0.2"]
}

# set(тип) — список без дублей, порядок не гарантирован
variable "features" {
  type    = set(string)
  default = ["auth", "api", "metrics", "auth"]  # дубль auth удалится
}

# map(тип) — ключ-значение, все значения одного типа
variable "env_vars" {
  type = map(string)
  default = {
    LOG_LEVEL    = "info"
    DATABASE_URL = "localhost:5432"
    REDIS_URL    = "localhost:6379"
  }
}

# map(number) — числовые значения
variable "port_map" {
  type = map(number)
  default = {
    http  = 80
    https = 443
    app   = 8080
  }
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
# Обращение к элементам list
resource "local_file" "list_demo" {
  content = <<-CFG
    # Первый IP: ${var.allowed_ips[0]}
    # Второй IP: ${var.allowed_ips[1]}
    # Всего IP:  ${length(var.allowed_ips)}

    # Все IP через запятую:
    # ${join(", ", var.allowed_ips)}
  CFG
  filename = "/tmp/tf-vars/list_demo.txt"
}

# Обращение к map по ключу
resource "local_file" "map_demo" {
  content = <<-CFG
    LOG_LEVEL=${var.env_vars["LOG_LEVEL"]}
    PORT_HTTP=${var.port_map["http"]}
    PORT_APP=${var.port_map["app"]}
  CFG
  filename = "/tmp/tf-vars/map_demo.txt"
}
EOF
terraform apply -auto-approve
```{{execute}}

```bash
cat /tmp/tf-vars/list_demo.txt
cat /tmp/tf-vars/map_demo.txt
```{{execute}}

## any — универсальный тип

```bash
cat << 'EOF'
type = any  <- принять любой тип

  Используется когда тип заранее неизвестен (редко нужно).
  Лучше всегда указывать конкретный тип — это документация.
EOF
```{{execute}}
