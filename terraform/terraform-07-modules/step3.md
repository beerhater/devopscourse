# Шаг 3: Вызываем модуль через `module` блок

## Синтаксис module блока

```bash
cat << 'EOF'
module "ИМЯ" {
  source = "ПУТЬ_К_МОДУЛЮ"   # обязательный

  # Входные переменные модуля (все variable без default)
  переменная = значение

  # Управление версией (только для реестра и git)
  version = "~> 1.0"

  # depends_on, count, for_each — работают с модулями
}

# Ссылка на outputs модуля:
module.ИМЯ.ИМЯ_OUTPUT
EOF
```{{execute}}

## Создаём root module

```bash
cd ~/tf-modules
```{{execute}}

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
```{{execute}}

```bash
cat > main.tf << 'EOF'
# Вызов модуля для dev окружения
module "app_dev" {
  source = "./modules/app-config"

  project     = "cr-it"
  environment = "dev"
  app_port    = 3000
  extra_env_vars = {
    DEBUG       = "true"
    HOT_RELOAD  = "true"
  }
}

# Тот же модуль для production
module "app_prod" {
  source = "./modules/app-config"

  project     = "cr-it"
  environment = "production"
  app_port    = 8080
  extra_env_vars = {
    SENTRY_DSN  = "https://sentry.example.com/1"
    METRICS_URL = "https://metrics.example.com"
  }
}
EOF
```{{execute}}

```bash
cat > outputs.tf << 'EOF'
output "dev_deploy_id"  { value = module.app_dev.deploy_id }
output "prod_deploy_id" { value = module.app_prod.deploy_id }
output "dev_config"     { value = module.app_dev.config_path }
output "prod_config"    { value = module.app_prod.config_path }
EOF
```{{execute}}

## terraform init — скачивает локальные модули тоже

```bash
terraform init
```{{execute}}

```bash
cat << 'EOF'
.terraform/modules/ — Terraform кэширует модули:
  .terraform/modules/modules.json  <- реестр модулей
  .terraform/modules/app_dev/      <- для локальных: symlink или копия
  .terraform/modules/app_prod/
EOF
```{{execute}}

```bash
terraform apply -auto-approve
```{{execute}}

```bash
echo "=== OUTPUTS ==="
terraform output

echo ""
echo "=== DEV CONFIG ==="
cat /tmp/modules-demo/dev/cr-it.conf

echo ""
echo "=== PROD CONFIG ==="
cat /tmp/modules-demo/production/cr-it.conf

echo ""
echo "=== DEV ENV ==="
cat /tmp/modules-demo/dev/.env
```{{execute}}
