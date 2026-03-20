# Шаг 5: terraform init

`terraform init` — первая команда в любом проекте.
Скачивает провайдеры, инициализирует backend, готовит рабочую директорию.

## Запускаем init

```bash
cd ~/terraform-intro
terraform init
```{{execute}}

```bash
# Что создалось?
ls -la
```{{execute}}

```bash
# .terraform/ — скачанные провайдеры
ls .terraform/providers/registry.terraform.io/hashicorp/
```{{execute}}

```bash
# .terraform.lock.hcl — lock-файл провайдеров (как package-lock.json)
cat .terraform.lock.hcl
```{{execute}}

## Что делает terraform init

```bash
cat << 'EOF'
terraform init выполняет:

  1. Читает блоки required_providers и backend
  2. Скачивает провайдеры из Terraform Registry
     → .terraform/providers/registry.terraform.io/.../
  3. Создаёт .terraform.lock.hcl с зафиксированными версиями и хешами
  4. Инициализирует backend (где хранить state-файл)

Когда нужно повторно запускать init:
  - Добавили новый провайдер
  - Изменили версию провайдера
  - Сменили backend
  - Склонировали проект на новую машину
  - Удалили .terraform/ директорию
EOF
```{{execute}}

## .terraform.lock.hcl — зачем коммитить в Git

```bash
cat << 'EOF'
.terraform.lock.hcl содержит:
  - Точные версии всех провайдеров
  - Хеши бинарников (для безопасности)

НУЖНО коммитить в Git:
  git add .terraform.lock.hcl

НЕ нужно коммитить в Git:
  .terraform/          ← сами бинарники провайдеров (большие)
  terraform.tfstate    ← state-файл (может содержать секреты)
  *.tfvars             ← если содержат секреты

Типичный .gitignore для Terraform:
  .terraform/
  terraform.tfstate
  terraform.tfstate.backup
  *.tfvars
  !example.tfvars
EOF
```{{execute}}

```bash
# Создаём .gitignore
cat > ~/terraform-intro/.gitignore << 'EOF'
.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfvars
!example.tfvars
.terraform.lock.hcl
EOF
cat ~/terraform-intro/.gitignore
```{{execute}}
