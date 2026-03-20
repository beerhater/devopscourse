# Шаг 4: Вложенные модули и передача данных

Модуль может вызывать другие модули. Данные текут через outputs → inputs.

## Создаём второй модуль — nginx-config

```bash
mkdir -p ~/tf-modules/modules/nginx-config
```{{execute}}

```bash
cat > ~/tf-modules/modules/nginx-config/versions.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.4" }
  }
}
EOF
```{{execute}}

```bash
cat > ~/tf-modules/modules/nginx-config/variables.tf << 'EOF'
variable "server_name"   { type = string }
variable "upstream_host" { type = string; default = "127.0.0.1" }
variable "upstream_port" { type = number; default = 8080 }
variable "output_dir"    { type = string; default = "/tmp/modules-demo" }
variable "environment"   { type = string; default = "dev" }
EOF
```{{execute}}

```bash
cat > ~/tf-modules/modules/nginx-config/main.tf << 'EOF'
resource "local_file" "nginx_conf" {
  content = <<-NGINX
    upstream ${var.server_name}_backend {
      server ${var.upstream_host}:${var.upstream_port};
    }

    server {
      listen 80;
      server_name ${var.server_name}.example.com;

      location / {
        proxy_pass http://${var.server_name}_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
      }
    }
  NGINX
  filename        = "${var.output_dir}/${var.environment}/nginx/${var.server_name}.conf"
  file_permission = "0644"
}
EOF
```{{execute}}

```bash
cat > ~/tf-modules/modules/nginx-config/outputs.tf << 'EOF'
output "config_path" {
  value = local_file.nginx_conf.filename
}
output "upstream" {
  value = "${var.upstream_host}:${var.upstream_port}"
}
EOF
```{{execute}}

## Используем оба модуля вместе — outputs одного = inputs другого

```bash
cd ~/tf-modules
cat > main.tf << 'EOF'
# Модуль 1: конфиг приложения
module "app_dev" {
  source      = "./modules/app-config"
  project     = "cr-it"
  environment = "dev"
  app_port    = 3000
}

# Модуль 2: nginx — использует OUTPUT модуля 1
# module.app_dev.app_name  и  port из переменной
module "nginx_dev" {
  source = "./modules/nginx-config"

  server_name   = module.app_dev.app_name  # <- output модуля 1
  upstream_port = 3000
  environment   = "dev"
  output_dir    = "/tmp/modules-demo"
}

# Production
module "app_prod" {
  source      = "./modules/app-config"
  project     = "cr-it"
  environment = "production"
  app_port    = 8080
}

module "nginx_prod" {
  source = "./modules/nginx-config"

  server_name   = module.app_prod.app_name
  upstream_port = 8080
  environment   = "production"
  output_dir    = "/tmp/modules-demo"
}
EOF
```{{execute}}

```bash
cat > outputs.tf << 'EOF'
output "dev_app"   { value = module.app_dev.config_path }
output "dev_nginx" { value = module.nginx_dev.config_path }
output "prod_app"  { value = module.app_prod.config_path }
output "prod_nginx"{ value = module.nginx_prod.config_path }
EOF
```{{execute}}

```bash
terraform init && terraform apply -auto-approve
```{{execute}}

```bash
echo "=== NGINX DEV ==="
cat /tmp/modules-demo/dev/nginx/cr-it-dev.conf

echo ""
echo "=== NGINX PROD ==="
cat /tmp/modules-demo/production/nginx/cr-it-production.conf
```{{execute}}
