# Шаг 1: Установка Terraform и провайдер local

```bash
# Устанавливаем Terraform
apt-get update -qq && apt-get install -y -qq gnupg curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -qq && apt-get install -y terraform
terraform version
```{{execute}}

## Что умеет провайдер local

```bash
cat << 'EOF'
Провайдер hashicorp/local управляет локальной файловой системой.

РЕСУРСЫ (resource) — создают/меняют/удаляют:
  local_file              создать файл с заданным содержимым
  local_sensitive_file    то же, но содержимое скрыто в логах/state

DATA SOURCES (data) — только читают существующее:
  local_file              прочитать содержимое файла
  local_sensitive_file    прочитать файл (содержимое скрыто)

Используется для:
  - Обучения Terraform без облака
  - Генерации конфиг-файлов
  - Тестирования модулей локально
  - CI/CD: генерация .env файлов перед деплоем
EOF
```{{execute}}

## Создаём рабочую директорию

```bash
mkdir -p ~/tf-resources && cd ~/tf-resources
```{{execute}}

```bash
cat > providers.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}
EOF
terraform init
```{{execute}}
