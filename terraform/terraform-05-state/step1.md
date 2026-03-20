# Шаг 1: Установка и концепция State

```bash
apt-get update -qq && apt-get install -y -qq gnupg curl jq
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor   -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]   https://apt.releases.hashicorp.com $(lsb_release -cs) main"   | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -qq && apt-get install -y terraform
terraform version
```{{execute}}

## Зачем нужен state?

```bash
cat << 'EOF'
Проблема без state:

  terraform apply   <- создал EC2 instance i-abc123
  terraform apply   <- откуда Terraform знает что i-abc123 уже существует?
                       Как связать resource "aws_instance" "web" с i-abc123?

Решение — state файл:

  terraform.tfstate хранит:
    ресурс "aws_instance" "web"  ->  реальный объект i-abc123
    его атрибуты: ip, ami, type, tags...
    метаданные: provider, version, dependencies

  При следующем apply Terraform:
    1. Читает .tf файлы (желаемое состояние)
    2. Читает state (известное состояние)
    3. Опрашивает API провайдера (реальное состояние)
    4. Вычисляет diff -> план
EOF
```{{execute}}

## Создаём учебный проект

```bash
mkdir -p ~/tf-state && cd ~/tf-state
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
```{{execute}}

```bash
cat > main.tf << 'EOF'
resource "random_id" "server_id" { byte_length = 8 }

resource "random_password" "db_pass" {
  length  = 16
  special = false
}

resource "local_file" "server_config" {
  content = <<-CFG
    server_id = ${random_id.server_id.hex}
    db_pass   = ${random_password.db_pass.result}
    host      = app-server-01
    port      = 8080
  CFG
  filename        = "/tmp/tf-state-demo/server.conf"
  file_permission = "0644"
}
EOF
```{{execute}}

```bash
terraform init
terraform apply -auto-approve
```{{execute}}
