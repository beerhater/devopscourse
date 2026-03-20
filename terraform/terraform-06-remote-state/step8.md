# Шаг 8: terraform_remote_state — чтение outputs другого state

## Концепция: разделение инфраструктуры

```bash
cat << 'EOF'
Большой проект делится на несколько независимых state:

  networking/     <- VPC, суbnets, security groups
    output "vpc_id"
    output "subnet_ids"

  database/       <- RDS, ElastiCache
    output "db_host"
    output "db_port"

  application/    <- EC2, ECS, Lambda
    Читает outputs из networking и database

Преимущества:
  - Разные команды управляют своими частями
  - Меньше риск при apply (меньше ресурсов)
  - Быстрее plan (меньше ресурсов для refresh)
  - Разные права доступа к state
EOF
```{{execute}}

## Создаём два взаимосвязанных state

```bash
# ПРОЕКТ 1: "networking" — создаёт базовую инфраструктуру
mkdir -p ~/tf-remote-data/networking && cd ~/tf-remote-data/networking
```{{execute}}

```bash
cat > providers.tf << 'EOF'
terraform {
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
  backend "s3" {
    bucket   = "terraform-state"
    key      = "remote-data/networking/terraform.tfstate"
    region   = "us-east-1"
    endpoints = { s3 = "http://localhost:9000" }
    access_key = "minioadmin"; secret_key = "minioadmin"
    skip_credentials_validation = true; skip_requesting_account_id = true
    skip_region_validation = true; skip_metadata_api_check = true
    use_path_style = true; encrypt = false
  }
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
resource "random_id" "vpc_id"    { byte_length = 4 }
resource "random_id" "subnet_a"  { byte_length = 4 }
resource "random_id" "subnet_b"  { byte_length = 4 }

resource "local_file" "network_config" {
  content  = "vpc_id=${random_id.vpc_id.hex}
region=ru-central1
"
  filename = "/tmp/remote-data/networking.conf"
}

output "vpc_id"     { value = random_id.vpc_id.hex }
output "subnet_ids" { value = [random_id.subnet_a.hex, random_id.subnet_b.hex] }
output "region"     { value = "ru-central1" }
EOF
terraform init && terraform apply -auto-approve
echo "VPC_ID: $(terraform output -raw vpc_id)"
```{{execute}}

```bash
# ПРОЕКТ 2: "application" — использует outputs из networking
mkdir -p ~/tf-remote-data/application && cd ~/tf-remote-data/application
```{{execute}}

```bash
cat > providers.tf << 'EOF'
terraform {
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
  backend "s3" {
    bucket   = "terraform-state"
    key      = "remote-data/application/terraform.tfstate"
    region   = "us-east-1"
    endpoints = { s3 = "http://localhost:9000" }
    access_key = "minioadmin"; secret_key = "minioadmin"
    skip_credentials_validation = true; skip_requesting_account_id = true
    skip_region_validation = true; skip_metadata_api_check = true
    use_path_style = true; encrypt = false
  }
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
# Читаем outputs из networking state
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket   = "terraform-state"
    key      = "remote-data/networking/terraform.tfstate"
    region   = "us-east-1"
    endpoints = { s3 = "http://localhost:9000" }
    access_key = "minioadmin"
    secret_key = "minioadmin"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    use_path_style              = true
  }
}

resource "random_id" "app_id" { byte_length = 6 }

resource "local_file" "app_config" {
  content = <<-CFG
    # Данные из networking state:
    vpc_id    = ${data.terraform_remote_state.networking.outputs.vpc_id}
    subnet_a  = ${data.terraform_remote_state.networking.outputs.subnet_ids[0]}
    subnet_b  = ${data.terraform_remote_state.networking.outputs.subnet_ids[1]}
    region    = ${data.terraform_remote_state.networking.outputs.region}

    # Данные application:
    app_id    = ${random_id.app_id.hex}
  CFG
  filename = "/tmp/remote-data/application.conf"
}

output "app_id" { value = random_id.app_id.hex }
output "vpc_id" { value = data.terraform_remote_state.networking.outputs.vpc_id }
EOF
terraform init && terraform apply -auto-approve
```{{execute}}

```bash
cat /tmp/remote-data/application.conf
```{{execute}}
