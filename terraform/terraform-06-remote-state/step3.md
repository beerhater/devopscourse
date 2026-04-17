# Шаг 3: terraform init -migrate-state

Как перенести уже существующий локальный state в remote backend.

## Создаём проект с локальным state

```bash
mkdir -p ~/tf-migrate && cd ~/tf-migrate
```{{execute}}

```bash
# Пока без backend — локальный state
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
resource "random_id" "app" { byte_length = 8 }

resource "local_file" "app" {
  content = <<-CFG
    id=${random_id.app.hex}
    created=locally
  CFG
  filename = "/tmp/migrate-demo/app.conf"
}

output "app_id" { value = random_id.app.hex }
EOF
terraform init && terraform apply -auto-approve
```{{execute}}

```bash
# State локальный
ls -la terraform.tfstate
cat terraform.tfstate | jq '.serial, .resources | length'
```{{execute}}

```bash
# Запоминаем текущий app_id
echo "Текущий app_id: $(terraform output -raw app_id)"
```{{execute}}

## Мигрируем в remote backend

```bash
# Добавляем backend в providers.tf
cat > providers.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }

  backend "s3" {
    bucket   = "terraform-state"
    key      = "migrate-demo/terraform.tfstate"
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
# -migrate-state: перенести state из локального в remote
terraform init -migrate-state
```{{execute}}

```bash
# Вводим yes для подтверждения миграции
```{{execute}}

```bash
# Локальный tfstate стал tfstate.backup (сохранился как запасной)
ls -la terraform.tfstate*
```{{execute}}

```bash
# State теперь в MinIO
mc ls local/terraform-state/migrate-demo/
```{{execute}}

```bash
# app_id тот же — данные перенесены!
echo "app_id после миграции: $(terraform output -raw app_id)"
```{{execute}}

```bash
cat << 'EOF'
Флаги terraform init для работы с backend:

  -migrate-state      перенести state из старого backend в новый
  -reconfigure        сбросить backend (НЕ мигрировать state)
  -backend=false      не инициализировать backend

  Когда нужен -reconfigure:
    - Полностью поменяли backend (другой тип)
    - Хотите начать с чистого листа
    - State не нужен (throwaway environment)

  Когда нужен -migrate-state:
    - local -> S3 (первая миграция)
    - S3 bucket A -> S3 bucket B
    - Terraform Cloud -> S3
EOF
```{{execute}}
