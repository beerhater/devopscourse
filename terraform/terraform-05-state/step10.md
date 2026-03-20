# Шаг 10: Итоговое задание — полный цикл работы со state

Закрепим всё: создание, drift, rm/mv, backup, восстановление.

## Создаём проект

```bash
mkdir -p ~/tf-state-final && cd ~/tf-state-final
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
terraform init
```{{execute}}

```bash
cat > main.tf << 'EOF'
variable "env"  { type = string; default = "staging" }

resource "random_id"       "app_id"  { byte_length = 8 }
resource "random_password" "db_pass" { length = 20; special = false }

resource "local_file" "app_config" {
  content = <<-CFG
    env       = ${var.env}
    app_id    = ${random_id.app_id.hex}
    timestamp = ${timestamp()}
  CFG
  filename        = "/tmp/state-final/${var.env}/app.conf"
  file_permission = "0644"
}

resource "local_sensitive_file" "db_secret" {
  content         = "DB_PASS=${random_password.db_pass.result}
"
  filename        = "/tmp/state-final/${var.env}/.env"
  file_permission = "0600"
}

output "app_id"  { value = random_id.app_id.hex }
output "env"     { value = var.env }
output "serial"  { value = "check: cat terraform.tfstate | jq .serial" }
EOF
terraform apply -auto-approve
```{{execute}}

## 1. Изучаем state

```bash
echo "=== РЕСУРСЫ В STATE ==="
terraform state list

echo ""
echo "=== SERIAL И LINEAGE ==="
cat terraform.tfstate | jq '{serial, lineage, terraform_version}'

echo ""
echo "=== ПАРОЛЬ В STATE (PLAINTEXT!) ==="
cat terraform.tfstate | jq '.resources[] | select(.type == "random_password") | .instances[].attributes.result'
```{{execute}}

## 2. Drift: удаляем файл вручную

```bash
rm -f /tmp/state-final/staging/app.conf
echo "Файл удалён вручную (drift!)"
terraform plan
```{{execute}}

```bash
terraform apply -auto-approve
echo "Drift исправлен"
```{{execute}}

## 3. state rm и восстановление

```bash
OLD_SERIAL=$(cat terraform.tfstate | jq .serial)
terraform state rm random_id.app_id
echo "После rm serial: $(cat terraform.tfstate | jq .serial) (был: $OLD_SERIAL)"
terraform apply -auto-approve
echo "Новый app_id: $(terraform output -raw app_id)"
```{{execute}}

## 4. state mv (переименование)

```bash
terraform state mv local_file.app_config local_file.main_config
terraform state list
terraform state mv local_file.main_config local_file.app_config
```{{execute}}

## 5. Backup и восстановление

```bash
cp terraform.tfstate good_backup.tfstate
echo "=== Портим state ==="
echo '{"version":4,"serial":999,"lineage":"bad"}' > terraform.tfstate
terraform plan 2>&1 | head -5
echo "=== Восстанавливаем ==="
cp good_backup.tfstate terraform.tfstate
terraform plan | tail -3
echo "State восстановлен из backup!"
```{{execute}}

## 6. Итоговая проверка

```bash
echo "=== ФИНАЛЬНЫЙ STATE ==="
terraform state list
echo ""
echo "=== OUTPUTS ==="
terraform output
echo ""
echo "=== .gitignore ==="
cat << 'EOF'
terraform.tfstate      <- НИКОГДА в git
terraform.tfstate.*    <- backup тоже
.terraform/            <- бинарники провайдеров
EOF
terraform destroy -auto-approve
```{{execute}}
