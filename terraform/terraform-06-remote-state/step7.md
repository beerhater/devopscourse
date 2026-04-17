# Шаг 7: terraform workspace

`workspace` — встроенный способ хранить несколько state в одном backend.

## Концепция workspace

```bash
cat << 'EOF'
terraform workspace — изолированные состояния в одном backend.

  По умолчанию: workspace "default"
  Структура в S3:
    key                            <- workspace default
    env:/staging/key               <- workspace staging
    env:/production/key            <- workspace production

  Внутри конфига:
    terraform.workspace  <- имя текущего workspace

  Когда использовать:
    ✅ Быстрое создание ephemeral окружений (PR environments)
    ✅ Тестирование изменений
    ✅ Простые проекты

  Когда НЕ использовать workspace:
    ❌ Production vs non-production (разные bucket лучше)
    ❌ Разные конфигурации infrastructure
    ❌ Разные права доступа (один backend = один доступ)
EOF
```{{execute}}

## Работа с workspace

```bash
mkdir -p ~/tf-workspace && cd ~/tf-workspace
```{{execute}}

```bash
cat > providers.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }

  backend "s3" {
    bucket   = "terraform-state"
    key      = "workspace-demo/terraform.tfstate"
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
cat > main.tf << 'EOF'
locals {
  env       = terraform.workspace
  is_prod   = terraform.workspace == "production"
  replicas  = local.is_prod ? 3 : 1
}

resource "random_id" "id" { byte_length = 6 }

resource "local_file" "config" {
  content = <<-CFG
    workspace=${local.env}
    replicas=${local.replicas}
    id=${random_id.id.hex}
  CFG
  filename = "/tmp/workspace-demo/${local.env}/app.conf"
}

output "workspace" { value = terraform.workspace }
output "replicas"  { value = local.replicas }
output "id"        { value = random_id.id.hex }
EOF
terraform init
```{{execute}}

```bash
# Все workspace команды
cat << 'EOF'
terraform workspace list      <- список workspace
terraform workspace new NAME  <- создать новый
terraform workspace select NAME <- переключиться
terraform workspace show      <- текущий
terraform workspace delete NAME <- удалить (нельзя удалить с ресурсами)
EOF
```{{execute}}

```bash
# Текущий workspace
terraform workspace show
terraform workspace list
```{{execute}}

```bash
# Применяем в default
terraform apply -auto-approve
terraform output
```{{execute}}

```bash
# Создаём workspace staging
terraform workspace new staging
terraform workspace show
terraform apply -auto-approve
terraform output
```{{execute}}

```bash
# Создаём workspace production
terraform workspace new production
terraform apply -auto-approve
terraform output
```{{execute}}

```bash
# Смотрим все state файлы в MinIO
mc ls local/terraform-state/workspace-demo/
mc ls "local/terraform-state/env:/staging/" 2>/dev/null || true
mc ls local/terraform-state/ --recursive | grep workspace
```{{execute}}

```bash
# Переключаемся обратно в default
terraform workspace select default
terraform output
```{{execute}}
