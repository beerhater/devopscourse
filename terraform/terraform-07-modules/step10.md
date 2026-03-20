# Шаг 10: Итоговое задание — полная библиотека модулей

Создадим три модуля и полноценный проект который их использует.

## Структура

```bash
mkdir -p ~/tf-final-modules/{modules/{service,secrets,monitoring},envs/{dev,production}}
cd ~/tf-final-modules
```{{execute}}

## Модуль 1: service

```bash
cat > modules/service/versions.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
}
EOF
cat > modules/service/variables.tf << 'EOF'
variable "name"        { type = string }
variable "environment" { type = string }
variable "port"        { type = number; default = 8080 }
variable "replicas"    { type = number; default = 1 }
variable "output_dir"  { type = string; default = "/tmp/final-modules" }
EOF
cat > modules/service/main.tf << 'EOF'
locals {
  full_name = "${var.name}-${var.environment}"
  is_prod   = var.environment == "production"
}

resource "random_id" "id" { byte_length = 6 }

resource "local_file" "config" {
  content  = "name=${local.full_name}
port=${var.port}
replicas=${var.replicas}
id=${random_id.id.hex}
"
  filename = "${var.output_dir}/${var.environment}/services/${var.name}.conf"
  file_permission = "0644"
}
EOF
cat > modules/service/outputs.tf << 'EOF'
output "id"       { value = random_id.id.hex }
output "name"     { value = local.full_name }
output "port"     { value = var.port }
output "config"   { value = local_file.config.filename }
EOF
```{{execute}}

## Модуль 2: secrets

```bash
cat > modules/secrets/versions.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
}
EOF
cat > modules/secrets/variables.tf << 'EOF'
variable "service_name" { type = string }
variable "environment"  { type = string }
variable "output_dir"   { type = string; default = "/tmp/final-modules" }
EOF
cat > modules/secrets/main.tf << 'EOF'
resource "random_password" "db"  { length = 24; special = false }
resource "random_string"   "key" { length = 32; special = false }

resource "local_sensitive_file" "secrets" {
  content         = "DB_PASSWORD=${random_password.db.result}
APP_KEY=${random_string.key.result}
"
  filename        = "${var.output_dir}/${var.environment}/secrets/${var.service_name}.env"
  file_permission = "0600"
}
EOF
cat > modules/secrets/outputs.tf << 'EOF'
output "secrets_path" { value = local_sensitive_file.secrets.filename }
output "db_password"  { value = random_password.db.result; sensitive = true }
EOF
```{{execute}}

## Модуль 3: monitoring

```bash
cat > modules/monitoring/versions.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.4" }
  }
}
EOF
cat > modules/monitoring/variables.tf << 'EOF'
variable "services"    { type = list(object({ name = string; port = number })) }
variable "environment" { type = string }
variable "output_dir"  { type = string; default = "/tmp/final-modules" }
EOF
cat > modules/monitoring/main.tf << 'EOF'
resource "local_file" "prometheus" {
  content = <<-YAML
    global:
      scrape_interval: ${var.environment == "production" ? "15s" : "60s"}

    scrape_configs:
    ${join("
    ", [for svc in var.services :
      "- job_name: ${svc.name}
      static_configs:
        - targets: ['localhost:${svc.port}']"
    ])}
  YAML
  filename = "${var.output_dir}/${var.environment}/prometheus.yml"
}
EOF
cat > modules/monitoring/outputs.tf << 'EOF'
output "prometheus_config" { value = local_file.prometheus.filename }
EOF
```{{execute}}

## Root module

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

cat > main.tf << 'EOF'
locals {
  services = {
    api     = { port = 8080, replicas_prod = 3, replicas_dev = 1 }
    worker  = { port = 8081, replicas_prod = 2, replicas_dev = 1 }
    metrics = { port = 9090, replicas_prod = 1, replicas_dev = 1 }
  }
  env = "production"
}

module "services" {
  for_each   = local.services
  source     = "./modules/service"
  name       = each.key
  environment = local.env
  port       = each.value.port
  replicas   = each.value.replicas_prod
  output_dir = "/tmp/final-modules"
}

module "secrets" {
  for_each     = local.services
  source       = "./modules/secrets"
  service_name = each.key
  environment  = local.env
  output_dir   = "/tmp/final-modules"
}

module "monitoring" {
  source      = "./modules/monitoring"
  environment = local.env
  output_dir  = "/tmp/final-modules"
  services    = [for name, svc in local.services : { name = name; port = svc.port }]
}
EOF

cat > outputs.tf << 'EOF'
output "service_ids"    { value = {for k, m in module.services : k => m.id} }
output "service_ports"  { value = {for k, m in module.services : k => m.port} }
output "prometheus"     { value = module.monitoring.prometheus_config }
EOF
```{{execute}}

```bash
terraform init && terraform apply -auto-approve
```{{execute}}

```bash
echo "=== OUTPUTS ===" && terraform output
echo ""
echo "=== СЕРВИСЫ ===" && ls /tmp/final-modules/production/services/
echo ""
echo "=== СЕКРЕТЫ ===" && ls /tmp/final-modules/production/secrets/
echo ""
echo "=== PROMETHEUS ===" && cat /tmp/final-modules/production/prometheus.yml
```{{execute}}

```bash
terraform destroy -auto-approve
```{{execute}}
