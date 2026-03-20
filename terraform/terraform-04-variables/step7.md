# Шаг 7: Sensitive переменные и outputs

## sensitive = true в variable

```bash
cd ~/tf-variables
cat << 'EOF'
sensitive = true в variable:
  - Значение скрыто в terraform plan и apply выводе
  - Terraform покажет: (sensitive value)
  - В state всё равно хранится (state защищайте отдельно!)
  - Передавать через TF_VAR_* или -var (не в tfvars если они в git)
EOF
```{{execute}}

```bash
cat > variables.tf << 'EOF'
variable "project_name" { type = string; default = "cr-it" }
variable "environment"  { type = string; default = "dev" }
variable "app_port"     { type = number; default = 8080 }
variable "replicas"     { type = number; default = 1 }

# Sensitive переменные
variable "db_password" {
  type        = string
  sensitive   = true
  description = "Пароль базы данных (передавать через TF_VAR_db_password)"
  default     = "changeme123"
}

variable "api_secret" {
  type        = string
  sensitive   = true
  description = "Секретный ключ API"
  default     = "secret-api-key-placeholder"
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
resource "local_file" "app_config" {
  content  = "project=${var.project_name}
env=${var.environment}
"
  filename = "/tmp/tf-sensitive/app.conf"
}

resource "local_sensitive_file" "secrets" {
  content = <<-ENV
    DB_PASSWORD=${var.db_password}
    API_SECRET=${var.api_secret}
  ENV
  filename        = "/tmp/tf-sensitive/.env"
  file_permission = "0600"
}
EOF
```{{execute}}

```bash
# В plan sensitive значения скрыты
terraform plan
```{{execute}}

```bash
terraform apply -auto-approve
cat /tmp/tf-sensitive/app.conf
echo "(sensitive файл создан: /tmp/tf-sensitive/.env)"
```{{execute}}

## Передача секретов через переменные окружения

```bash
cat << 'EOF'
Правило: никогда не коммитить секреты в git.

Безопасные способы передать sensitive переменные:

  1. TF_VAR_* (переменные окружения):
       export TF_VAR_db_password="RealSecurePass123!"
       terraform apply

  2. -var (командная строка — виден в истории bash!):
       terraform apply -var="db_password=pass"  <- ОСТОРОЖНО

  3. -var-file (файл переменных — не в git):
       terraform apply -var-file="secrets.tfvars"
       echo "secrets.tfvars" >> .gitignore

  4. Vault / AWS Secrets Manager / Yandex Lockbox:
       data "vault_generic_secret" "db" { path = "secret/db" }
       variable "db_password" { default = data.vault_generic_secret.db.data["password"] }
EOF
```{{execute}}

```bash
# Демонстрация TF_VAR_*
export TF_VAR_db_password="FromEnvVariable_SecurePass!"
terraform apply -auto-approve
terraform output -json | python3 -c "
import json,sys
d=json.load(sys.stdin)
print('db_password visible in JSON output:', d.get('db_password',{}).get('value','N/A'))
" 2>/dev/null || echo "(output не определён для db_password как sensitive)"
unset TF_VAR_db_password
```{{execute}}
