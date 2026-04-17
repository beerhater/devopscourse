# Шаг 9: Partial Backend Configuration — секреты не в коде

## Проблема: секреты в providers.tf

```bash
cat << 'EOF'
ПРОБЛЕМА:
  backend "s3" {
    access_key = "AKIAIOSFODNN7EXAMPLE"  <- секрет в git!
    secret_key = "wJalrXUtnFEMI/K7MDENG"  <- секрет в git!
  }

РЕШЕНИЕ: Partial Backend Configuration

  В providers.tf — только несекретные поля:
    bucket, key, region, encrypt

  Секреты — отдельно через:
    1. -backend-config файл (не в git)
    2. -backend-config="key=value" (CLI)
    3. Переменные окружения AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
    4. IAM роль EC2/ECS (лучший способ в AWS)
EOF
```{{execute}}

## Partial configuration на практике

```bash
mkdir -p ~/tf-partial && cd ~/tf-partial
```{{execute}}

```bash
# providers.tf — только несекретные поля, коммитится в git
cat > providers.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }

  # Partial backend: bucket и key только, без секретов
  backend "s3" {
    bucket  = "terraform-state"
    key     = "partial-demo/terraform.tfstate"
    region  = "us-east-1"
    encrypt = false
  }
}
EOF
```{{execute}}

```bash
# backend.hcl — секреты, НЕ коммитить в git!
cat > backend.hcl << 'EOF'
endpoints = { s3 = "http://localhost:9000" }
access_key = "minioadmin"
secret_key = "minioadmin"
skip_credentials_validation = true
skip_requesting_account_id  = true
skip_region_validation      = true
skip_metadata_api_check     = true
use_path_style              = true
EOF
```{{execute}}

```bash
cat > .gitignore << 'EOF'
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
backend.hcl
secrets.tfvars
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
resource "random_id" "id" { byte_length = 6 }
resource "local_file" "f" {
  content  = "id=${random_id.id.hex}"
  filename = "/tmp/partial-demo/app.conf"
}
output "id" { value = random_id.id.hex }
EOF
```{{execute}}

```bash
# Инициализация с backend-config файлом
terraform init -backend-config=backend.hcl
terraform apply -auto-approve
terraform output
```{{execute}}

## Переменные окружения для AWS

```bash
cat << 'EOF'
Для настоящего AWS — используем переменные окружения:

  export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
  export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG"
  export AWS_DEFAULT_REGION="eu-central-1"

  # Тогда backend может быть минимальным:
  backend "s3" {
    bucket  = "my-terraform-state"
    key     = "prod/terraform.tfstate"
    encrypt = true
    # region, access_key, secret_key — из переменных окружения
  }

В CI/CD (GitHub Actions):
  - ${{ secrets.AWS_ACCESS_KEY_ID }}
  - ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  Или: OIDC (без долгоживущих ключей)
EOF
```{{execute}}
