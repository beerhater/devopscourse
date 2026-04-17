# Шаг 8: Передача providers в модули

## Зачем передавать providers?

```bash
cat << 'EOF'
По умолчанию модуль наследует все providers из root module.

Но иногда нужно:
  - Развернуть модуль в другом регионе
  - Использовать разные AWS аккаунты
  - Мультиоблачные конфигурации

Тогда используем: configuration_aliases и передачу providers.
EOF
```{{execute}}

## configuration_aliases в модуле

```bash
mkdir -p ~/tf-modules/modules/multi-region
```{{execute}}

```bash
cat > ~/tf-modules/modules/multi-region/versions.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source                = "hashicorp/local"
      version               = "~> 2.4"
      configuration_aliases = [local.primary, local.secondary]
    }
  }
}
EOF
```{{execute}}

```bash
cat > ~/tf-modules/modules/multi-region/variables.tf << 'EOF'
variable "name"       { type = string }
variable "primary"    { type = string; default = "primary" }
variable "secondary"  { type = string; default = "secondary" }
variable "output_dir" { type = string; default = "/tmp/multi-region" }
EOF
```{{execute}}

```bash
cat > ~/tf-modules/modules/multi-region/main.tf << 'EOF'
resource "local_file" "primary_config" {
  provider = local.primary
  content  = <<-CFG
    region=${var.primary}
    name=${var.name}
  CFG
  filename = "${var.output_dir}/${var.primary}-${var.name}.conf"
}

resource "local_file" "secondary_config" {
  provider = local.secondary
  content  = <<-CFG
    region=${var.secondary}
    name=${var.name}
  CFG
  filename = "${var.output_dir}/${var.secondary}-${var.name}.conf"
}
EOF
```{{execute}}

```bash
cat > ~/tf-modules/modules/multi-region/outputs.tf << 'EOF'
output "primary_path"   { value = local_file.primary_config.filename }
output "secondary_path" { value = local_file.secondary_config.filename }
EOF
```{{execute}}

```bash
# Root module: передаём providers в модуль
cat > ~/tf-modules/main.tf << 'EOF'
provider "local" {
  alias = "region_a"
}
provider "local" {
  alias = "region_b"
}

module "app" {
  for_each = toset(["api", "worker", "scheduler"])
  source   = "./modules/app-config"

  project     = "cr-it"
  environment = "dev"
  app_port    = 8080
  output_dir  = "/tmp/modules-final"
}

module "multi" {
  source    = "./modules/multi-region"
  name      = "cr-it-app"
  primary   = "ru-central1"
  secondary = "eu-west1"
  output_dir = "/tmp/multi-region"

  providers = {
    local.primary   = local.region_a
    local.secondary = local.region_b
  }
}
EOF
```{{execute}}

```bash
cat > ~/tf-modules/outputs.tf << 'EOF'
output "app_names" {
  value = {for k, m in module.app : k => m.app_name}
}
output "multi_primary"   { value = module.multi.primary_path }
output "multi_secondary" { value = module.multi.secondary_path }
EOF
```{{execute}}

```bash
cd ~/tf-modules && terraform init && terraform apply -auto-approve
```{{execute}}

```bash
terraform output -json | jq .
ls /tmp/multi-region/
```{{execute}}
