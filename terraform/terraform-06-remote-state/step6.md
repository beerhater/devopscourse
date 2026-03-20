# Шаг 6: Несколько State — dev/staging/production

## Стратегия: разные ключи для разных окружений

```bash
cat << 'EOF'
Подход 1: Разные ключи (key) в одном bucket
  terraform-state/
    dev/terraform.tfstate
    staging/terraform.tfstate
    production/terraform.tfstate

Подход 2: Разные bucket для каждого окружения
  terraform-state-dev/terraform.tfstate
  terraform-state-staging/terraform.tfstate
  terraform-state-prod/terraform.tfstate

Подход 3: terraform workspace (встроенный)
  terraform-state/
    terraform.tfstate          <- workspace default
    env:/staging/terraform.tfstate
    env:/production/terraform.tfstate

Рекомендация для production:
  Разные bucket -> самая строгая изоляция
  Разные IAM роли для каждого окружения
EOF
```{{execute}}

## Подход с разными ключами (partial backend config)

```bash
mkdir -p ~/tf-multienv && cd ~/tf-multienv
```{{execute}}

```bash
# main.tf — одинаковый код для всех окружений
cat > main.tf << 'EOF'
variable "env"     { type = string }
variable "project" { type = string; default = "cr-it" }

resource "random_id" "id" { byte_length = 6 }

resource "local_file" "config" {
  content  = "project=${var.project}
env=${var.env}
id=${random_id.id.hex}
"
  filename = "/tmp/multienv/${var.env}/app.conf"
}

output "deploy_id"   { value = random_id.id.hex }
output "environment" { value = var.env }
EOF
```{{execute}}

```bash
# providers.tf БЕЗ ключа — partial configuration
cat > providers.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }

  backend "s3" {
    # key НЕ указан — передаётся через -backend-config
    bucket   = "terraform-state"
    region   = "us-east-1"
    endpoints = { s3 = "http://localhost:9000" }
    access_key = "minioadmin"
    secret_key = "minioadmin"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    use_path_style              = true
    encrypt = false
  }
}
EOF
```{{execute}}

```bash
# Файлы переменных для каждого окружения
cat > dev.tfvars     << 'EOF'
env = "dev"
EOF
cat > staging.tfvars << 'EOF'
env = "staging"
EOF
cat > prod.tfvars    << 'EOF'
env = "production"
EOF
```{{execute}}

```bash
# Деплой dev
terraform init -backend-config="key=multienv/dev/terraform.tfstate"
terraform apply -auto-approve -var-file=dev.tfvars
echo "DEV deploy_id: $(terraform output -raw deploy_id)"
```{{execute}}

```bash
# Деплой staging (новый init с другим ключом)
terraform init -reconfigure   -backend-config="key=multienv/staging/terraform.tfstate"
terraform apply -auto-approve -var-file=staging.tfvars
echo "STAGING deploy_id: $(terraform output -raw deploy_id)"
```{{execute}}

```bash
# Три отдельных state в MinIO
mc ls local/terraform-state/multienv/
```{{execute}}
