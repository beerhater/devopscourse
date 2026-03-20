# Шаг 5: terraform.tfvars и *.auto.tfvars

## Форматы файлов переменных

```bash
cat << 'EOF'
Terraform автоматически загружает:
  terraform.tfvars        HCL формат
  terraform.tfvars.json   JSON формат
  *.auto.tfvars           HCL, в алфавитном порядке
  *.auto.tfvars.json      JSON, в алфавитном порядке

Явно через флаг:
  terraform apply -var-file="prod.tfvars"
  terraform apply -var-file="secrets.tfvars"

Синтаксис HCL tfvars:
  имя = "значение"
  число = 42
  список = ["a", "b"]
  объект = { key = "value" }
EOF
```{{execute}}

## Создаём tfvars для разных окружений

```bash
cd ~/tf-variables
```{{execute}}

```bash
# dev — значения по умолчанию
cat > terraform.tfvars << 'EOF'
project_name = "cr-it"
environment  = "dev"
app_port     = 3000
replicas     = 1
EOF
```{{execute}}

```bash
# staging
cat > staging.tfvars << 'EOF'
project_name = "cr-it"
environment  = "staging"
app_port     = 8080
replicas     = 2
EOF
```{{execute}}

```bash
# production
cat > production.tfvars << 'EOF'
project_name    = "cr-it"
environment     = "production"
app_port        = 8080
replicas        = 3
allowed_regions = ["ru-central1", "eu-west1"]
EOF
```{{execute}}

```bash
# Общие переменные — загружаются всегда (auto.tfvars)
cat > common.auto.tfvars << 'EOF'
project_name = "cr-it"
EOF
```{{execute}}

```bash
# Применяем для staging
terraform apply -auto-approve -var-file=staging.tfvars
cat /tmp/tf-vars/validated.conf
```{{execute}}

```bash
# Применяем для production
terraform apply -auto-approve -var-file=production.tfvars
cat /tmp/tf-vars/validated.conf
```{{execute}}

## JSON формат tfvars

```bash
cat > secrets.auto.tfvars.json << 'EOF'
{
  "app_port": 9000,
  "replicas": 2
}
EOF
```{{execute}}

```bash
cat << 'EOF'
.gitignore для Terraform проекта:

  .terraform/
  terraform.tfstate
  terraform.tfstate.backup
  *.tfplan
  tfplan

  # Секреты — НЕ коммитить
  secrets.tfvars
  *secrets*.tfvars
  *.tfvars.json

  # Пример файлов — коммитить
  !example.tfvars
  !*.tfvars.example
EOF
```{{execute}}

```bash
rm -f secrets.auto.tfvars.json common.auto.tfvars
```{{execute}}
