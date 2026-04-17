# Шаг 2: Конфигурация backend "s3"

## Синтаксис S3 backend

```bash
cat << 'EOF'
terraform {
  backend "s3" {
    # Обязательные поля
    bucket = "terraform-state"          # имя bucket
    key    = "path/terraform.tfstate"   # путь внутри bucket

    # Для AWS
    region = "eu-central-1"

    # Для MinIO/Yandex/другие S3-совместимые
    endpoints = {
      s3 = "http://localhost:9000"      # или https://storage.yandexcloud.net
    }
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    use_path_style              = true  # важно для MinIO!

    # Безопасность
    encrypt = true                      # SSE шифрование

    # Locking (только AWS DynamoDB, YOS встроенный)
    dynamodb_table = "terraform-locks"  # только для AWS
  }
}
EOF
```{{execute}}

## Создаём первый remote state проект

```bash
mkdir -p ~/tf-remote && cd ~/tf-remote
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
    key      = "dev/terraform.tfstate"
    region   = "us-east-1"

    endpoints = {
      s3 = "http://localhost:9000"
    }

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
variable "env"     { type = string; default = "dev" }
variable "project" { type = string; default = "cr-it" }

resource "random_id" "deploy_id" { byte_length = 6 }

resource "local_file" "config" {
  content = <<-CFG
    env=${var.env}
    project=${var.project}
    deploy=${random_id.deploy_id.hex}
  CFG
  filename = "/tmp/remote-state/${var.env}/app.conf"
  file_permission = "0644"
}

output "deploy_id"   { value = random_id.deploy_id.hex }
output "config_path" { value = local_file.config.filename }
output "environment" { value = var.env }
EOF
```{{execute}}

## terraform init с remote backend

```bash
terraform init
```{{execute}}

```bash
# State теперь в MinIO!
terraform apply -auto-approve
```{{execute}}

```bash
# Локального tfstate нет
ls -la *.tfstate 2>/dev/null || echo "Локального state нет — он в MinIO!"
```{{execute}}

```bash
# Смотрим state в MinIO bucket
mc ls local/terraform-state/dev/
```{{execute}}
