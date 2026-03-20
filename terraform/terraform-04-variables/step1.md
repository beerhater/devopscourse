# Шаг 1: Установка и блок variable

```bash
apt-get update -qq && apt-get install -y -qq gnupg curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor   -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]   https://apt.releases.hashicorp.com $(lsb_release -cs) main"   | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -qq && apt-get install -y terraform
terraform version
```{{execute}}

## Блок variable — все поля

```bash
cat << 'EOF'
variable "имя" {
  type        = тип          # string, number, bool, list(...), map(...), etc.
  default     = значение     # если нет — переменная обязательна
  description = "Описание"   # документация
  sensitive   = true/false   # скрыть в логах (default: false)
  nullable    = true/false   # разрешить null (default: true)

  validation {
    condition     = выражение  # boolean; если false — ошибка
    error_message = "Текст ошибки"
  }
}
EOF
```{{execute}}

## Первый variables.tf

```bash
mkdir -p ~/tf-variables && cd ~/tf-variables
```{{execute}}

```bash
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

```bash
cat > variables.tf << 'EOF'
# Строка без default — ОБЯЗАТЕЛЬНАЯ переменная
variable "project_name" {
  type        = string
  description = "Название проекта (только буквы, цифры, дефис)"
}

# Строка с default — необязательная
variable "environment" {
  type        = string
  description = "Окружение деплоя"
  default     = "dev"
}

# Число
variable "app_port" {
  type        = number
  description = "Порт приложения"
  default     = 8080
}

# Булево
variable "debug_mode" {
  type        = bool
  description = "Включить debug режим"
  default     = false
}
EOF
```{{execute}}

```bash
# Используем переменные
cat > main.tf << 'EOF'
resource "local_file" "config" {
  content = <<-CFG
    project     = ${var.project_name}
    environment = ${var.environment}
    port        = ${var.app_port}
    debug       = ${var.debug_mode}
  CFG
  filename = "/tmp/tf-vars/basic.conf"
}
EOF
```{{execute}}

```bash
# Передаём обязательную переменную
terraform apply -auto-approve -var="project_name=cr-it"
cat /tmp/tf-vars/basic.conf
```{{execute}}
