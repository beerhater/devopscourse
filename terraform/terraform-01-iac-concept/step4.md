# Шаг 4: Провайдеры

Провайдер — это плагин, который умеет общаться с конкретным API.
Каждое облако, сервис, платформа имеет свой провайдер.

## Как работают провайдеры

```bash
cat << 'EOF'
Terraform Core              Provider Plugin
──────────────              ───────────────────────────────
Читает .tf файлы    →→→    Переводит в API-вызовы
Строит граф          →→→    aws_instance → AWS EC2 API
Вычисляет план       →→→    local_file → операции с ФС
Применяет изменения  →→→    kubernetes_pod → k8s API

Каждый провайдер:
  - Скачивается командой terraform init
  - Хранится в .terraform/providers/
  - Версионируется отдельно от Terraform
EOF
```{{execute}}

## Популярные провайдеры

```bash
cat << 'EOF'
Облачные провайдеры:
  hashicorp/aws           → Amazon Web Services
  hashicorp/google        → Google Cloud Platform
  hashicorp/azurerm       → Microsoft Azure
  yandex-cloud/yandex     → Yandex Cloud

Платформенные:
  hashicorp/kubernetes    → Kubernetes кластеры
  kreuzwerker/docker      → Docker контейнеры
  hashicorp/helm          → Helm charts

Утилитарные:
  hashicorp/local         → локальные файлы и директории ← будем использовать
  hashicorp/random        → генерация случайных значений
  hashicorp/null          → null_resource для хуков
  hashicorp/time          → задержки и временные ресурсы

Всего в Terraform Registry: 4000+ провайдеров
EOF
```{{execute}}

## Блок required_providers

```bash
cat > ~/terraform-intro/main.tf << 'EOF'
terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"   # namespace/name на registry.terraform.io
      version = "~> 2.4"            # ~> 2.4 означает >= 2.4.0, < 3.0.0
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Провайдер local не требует настройки — нет блока provider {}
# Для AWS нужно было бы:
# provider "aws" {
#   region = "eu-central-1"
# }

resource "local_file" "welcome" {
  content  = "Привет от Terraform!
Провайдер: hashicorp/local"
  filename = "/tmp/terraform-welcome.txt"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "local_file" "with_random" {
  content  = "Уникальный ID: ${random_id.suffix.hex}"
  filename = "/tmp/terraform-random.txt"
}
EOF
cat ~/terraform-intro/main.tf
```{{execute}}

## Версионирование провайдеров

```bash
cat << 'EOF'
Операторы версий:
  "= 2.4.0"    точная версия
  ">= 2.4.0"   не ниже
  "<= 2.4.0"   не выше
  "~> 2.4"     пессимистичная: >= 2.4, < 3.0 (только патч-обновления)
  "~> 2.4.1"   >= 2.4.1, < 2.5.0

Правило: всегда фиксируйте версии провайдеров в required_providers.
Иначе обновление провайдера может сломать план.
EOF
```{{execute}}
