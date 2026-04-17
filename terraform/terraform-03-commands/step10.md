# Шаг 10: Итоговое задание — полный CI/CD workflow

Сымитируем настоящий CI/CD pipeline: plan → review → apply → verify → destroy.

## Создаём финальный проект

```bash
mkdir -p ~/tf-workflow && cd ~/tf-workflow
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
cat > variables.tf << 'EOF'
variable "project"     { type = string; default = "cr-it" }
variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Допустимые значения: dev, staging, production."
  }
}
variable "version_tag"  { type = string; default = "1.0.0" }
variable "output_dir"   { type = string; default = "/tmp/workflow" }
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
locals {
  app_name    = "${var.project}-${var.environment}"
  log_level   = var.environment == "production" ? "warn" : "debug"
}

resource "random_id"     "deploy"    { byte_length = 6 }
resource "random_string" "api_key"   { length = 32; special = false }

resource "local_file" "app_config" {
  content = <<-CFG
    [app]
    name        = ${local.app_name}
    version     = ${var.version_tag}
    environment = ${var.environment}
    log_level   = ${local.log_level}
    deploy_id   = ${random_id.deploy.hex}
    output_dir  = ${var.output_dir}
  CFG
  filename        = "${var.output_dir}/${var.environment}/app.conf"
  file_permission = "0644"
}

resource "local_sensitive_file" "api_key" {
  content         = random_string.api_key.result
  filename        = "${var.output_dir}/${var.environment}/api.key"
  file_permission = "0600"
}

resource "local_file" "deploy_log" {
  content  = "Deployed: ${local.app_name} v${var.version_tag} (${random_id.deploy.hex})"
  filename = "${var.output_dir}/${var.environment}/deploy.log"
  depends_on = [local_file.app_config, local_sensitive_file.api_key]
}
EOF
```{{execute}}

```bash
cat > outputs.tf << 'EOF'
output "app_name"    { value = local.app_name }
output "deploy_id"   { value = random_id.deploy.hex }
output "config_path" { value = local_file.app_config.filename }
output "deploy_log"  { value = local_file.deploy_log.content }
EOF
```{{execute}}

## Шаг 1: Init + fmt + validate

```bash
terraform init && terraform fmt -recursive && terraform validate
echo "=== Init/Fmt/Validate: OK ==="
```{{execute}}

## Шаг 2: Plan с сохранением (CI pipeline)

```bash
cat > production.tfvars << 'EOF'
environment = "production"
version_tag = "2.1.0"
EOF

terraform plan -var-file=production.tfvars -out=prod.tfplan -no-color 2>&1 | tee plan_output.txt
echo "=== Plan сохранён в prod.tfplan ==="
```{{execute}}

## Шаг 3: Review (имитируем проверку плана)

```bash
echo "=== CODE REVIEW ПЛАНА ==="
terraform show prod.tfplan
```{{execute}}

## Шаг 4: Apply из сохранённого плана

```bash
terraform apply prod.tfplan
echo "=== Apply завершён ==="
```{{execute}}

## Шаг 5: Verify — проверяем результат

```bash
echo "=== OUTPUTS ==="
terraform output

echo ""
echo "=== СОЗДАННЫЕ ФАЙЛЫ ==="
ls -la /tmp/workflow/production/

echo ""
echo "=== КОНФИГ ==="
cat /tmp/workflow/production/app.conf

echo ""
echo "=== ЛОГ ДЕПЛОЯ ==="
cat /tmp/workflow/production/deploy.log
```{{execute}}

## Шаг 6: Update — новая версия

```bash
terraform apply -auto-approve   -var="environment=production"   -var="version_tag=2.2.0"

cat /tmp/workflow/production/app.conf
```{{execute}}

## Шаг 7: Cleanup

```bash
terraform destroy -auto-approve -var="environment=production"
echo "=== Ресурсы удалены ==="
```{{execute}}
