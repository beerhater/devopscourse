# Шаг 9: terraform.tfvars и порядок переменных

Terraform читает переменные из нескольких источников. Важно знать приоритеты.

## Порядок приоритетов переменных

```bash
cat << 'EOF'
Приоритет (от низшего к высшему):

  1. default в блоке variable {}          <- самый низкий
  2. terraform.tfvars                     <- автоматически загружается
  3. terraform.tfvars.json
  4. *.auto.tfvars (алфавитный порядок)
  5. *.auto.tfvars.json
  6. -var-file="file.tfvars"              <- явно указанный файл
  7. -var="key=value"                     <- CLI флаг
  8. TF_VAR_name переменная окружения     <- самый высокий

  Значение из более высокого приоритета ПЕРЕЗАПИСЫВАЕТ низший.
EOF
```{{execute}}

## terraform.tfvars

```bash
cd ~/tf-commands
```{{execute}}

```bash
# terraform.tfvars загружается автоматически
cat > terraform.tfvars << 'EOF'
env  = "production"
name = "webapp"
EOF
```{{execute}}

```bash
# Применяется без флагов
terraform plan
```{{execute}}

## *.auto.tfvars — несколько файлов переменных

```bash
cat > common.auto.tfvars << 'EOF'
name = "cr-it-app"
EOF

cat > env.auto.tfvars << 'EOF'
env = "staging"
EOF
```{{execute}}

```bash
# env.auto.tfvars перезапишет terraform.tfvars для env
terraform plan
```{{execute}}

## TF_VAR_* — переменные окружения

```bash
# Переменные окружения имеют наивысший приоритет
export TF_VAR_env="override-from-env"
terraform plan
```{{execute}}

```bash
unset TF_VAR_env
```{{execute}}

## Структура типичного проекта с tfvars

```bash
cat << 'EOF'
Типичная структура для нескольких окружений:

  .
  ├── main.tf
  ├── variables.tf
  ├── outputs.tf
  ├── providers.tf
  ├── terraform.tfvars          <- значения по умолчанию (dev)
  ├── prod.tfvars                <- prod переменные
  ├── staging.tfvars
  └── .gitignore                 <- *.tfvars если содержат секреты

Деплой в разные окружения:
  terraform apply -var-file=prod.tfvars
  terraform apply -var-file=staging.tfvars
  terraform apply                          <- использует terraform.tfvars (dev)
EOF
```{{execute}}

```bash
# Создаём разные конфиги для окружений
cat > staging.tfvars << 'EOF'
env  = "staging"
name = "cr-it-app"
EOF

terraform apply -auto-approve -var-file=staging.tfvars
cat /tmp/tf-cmds/cr-it-app-staging.conf
```{{execute}}
