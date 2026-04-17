# Шаг 10: Итоговое задание — полный remote state workflow

Поднимем полноценную инфраструктуру: два независимых state + remote data.

## Архитектура

```bash
cat << 'EOF'
terraform-state bucket (MinIO):
  final/shared/terraform.tfstate      <- shared ресурсы
  final/app/terraform.tfstate         <- application

Shared state создаёт:
  - random_id для "network"
  - Выводит: network_id, dns_zone

App state читает shared и создаёт:
  - Конфигурации приложения с сетевыми данными
  - random_password для БД
EOF
```{{execute}}

## Shared state

```bash
mkdir -p ~/tf-final-remote/shared && cd ~/tf-final-remote/shared
```{{execute}}

```bash
cat > providers.tf << 'EOF'
terraform {
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
  backend "s3" {
    bucket   = "terraform-state"; key = "final/shared/terraform.tfstate"
    region   = "us-east-1"; endpoints = { s3 = "http://localhost:9000" }
    access_key = "minioadmin"; secret_key = "minioadmin"
    skip_credentials_validation = true; skip_requesting_account_id = true
    skip_region_validation = true; skip_metadata_api_check = true
    use_path_style = true; encrypt = false
  }
}
EOF
cat > main.tf << 'EOF'
variable "project" { type = string; default = "cr-it" }
variable "region"  { type = string; default = "ru-central1" }

resource "random_id" "network_id" { byte_length = 6 }

resource "local_file" "shared_config" {
  content = <<-CFG
    project=${var.project}
    network=${random_id.network_id.hex}
    region=${var.region}
  CFG
  filename = "/tmp/final-remote/shared.conf"
}

output "network_id" { value = random_id.network_id.hex }
output "dns_zone"   { value = "${var.project}.internal" }
output "region"     { value = var.region }
output "project"    { value = var.project }
EOF
terraform init && terraform apply -auto-approve
echo "Shared state: OK | network_id=$(terraform output -raw network_id)"
```{{execute}}

## App state (читает shared)

```bash
mkdir -p ~/tf-final-remote/app && cd ~/tf-final-remote/app
```{{execute}}

```bash
cat > providers.tf << 'EOF'
terraform {
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
  backend "s3" {
    bucket   = "terraform-state"; key = "final/app/terraform.tfstate"
    region   = "us-east-1"; endpoints = { s3 = "http://localhost:9000" }
    access_key = "minioadmin"; secret_key = "minioadmin"
    skip_credentials_validation = true; skip_requesting_account_id = true
    skip_region_validation = true; skip_metadata_api_check = true
    use_path_style = true; encrypt = false
  }
}
EOF
cat > main.tf << 'EOF'
variable "env" { type = string; default = "production" }

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket   = "terraform-state"; key = "final/shared/terraform.tfstate"
    region   = "us-east-1"; endpoints = { s3 = "http://localhost:9000" }
    access_key = "minioadmin"; secret_key = "minioadmin"
    skip_credentials_validation = true; skip_requesting_account_id = true
    skip_region_validation = true; skip_metadata_api_check = true
    use_path_style = true
  }
}

resource "random_id"       "app_id"  { byte_length = 6 }
resource "random_password" "db_pass" { length = 20; special = false }

resource "local_file" "app_config" {
  content = <<-CFG
    [app]
    id         = ${random_id.app_id.hex}
    env        = ${var.env}

    [network]
    network_id = ${data.terraform_remote_state.shared.outputs.network_id}
    dns_zone   = ${data.terraform_remote_state.shared.outputs.dns_zone}
    region     = ${data.terraform_remote_state.shared.outputs.region}
  CFG
  filename = "/tmp/final-remote/${var.env}/app.conf"
}

resource "local_sensitive_file" "secrets" {
  content         = "DB_PASSWORD=${random_password.db_pass.result}"
  filename        = "/tmp/final-remote/${var.env}/.env"
  file_permission = "0600"
}

output "app_id"     { value = random_id.app_id.hex }
output "network_id" { value = data.terraform_remote_state.shared.outputs.network_id }
EOF
terraform init && terraform apply -auto-approve
```{{execute}}

## Проверяем результат

```bash
echo "=== App Config ===" && cat /tmp/final-remote/production/app.conf
echo ""
echo "=== State файлы в MinIO ==="
mc ls local/terraform-state/final/ --recursive
echo ""
echo "=== Версии state ==="
mc ls --versions local/terraform-state/final/app/
```{{execute}}

## Cleanup

```bash
cd ~/tf-final-remote/app && terraform destroy -auto-approve
cd ~/tf-final-remote/shared && terraform destroy -auto-approve
echo "Все ресурсы удалены"
```{{execute}}
