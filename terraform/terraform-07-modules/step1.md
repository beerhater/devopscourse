# Шаг 1: Установка и концепция модулей

```bash
apt-get update -qq && apt-get install -y -qq gnupg curl jq tree
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor   -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]   https://apt.releases.hashicorp.com $(lsb_release -cs) main"   | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -qq && apt-get install -y terraform
terraform version
```{{execute}}

## Зачем нужны модули?

```bash
cat << 'EOF'
БЕЗ модулей — копипаст для каждого окружения:

  dev/main.tf:
    resource "local_file" "config" { ... }    <- одинаково
    resource "local_file" "nginx" { ... }     <- одинаково
    resource "random_id" "id" { ... }         <- одинаково

  staging/main.tf:
    resource "local_file" "config" { ... }    <- копия
    resource "local_file" "nginx" { ... }     <- копия
    resource "random_id" "id" { ... }         <- копия

  production/main.tf:
    resource "local_file" "config" { ... }    <- ещё копия

  Проблема: исправить баг нужно в 3 местах. Забыл одно — сломалась prod.

С МОДУЛЯМИ — DRY (Don't Repeat Yourself):

  modules/app/               <- пишем ОДИН РАЗ
    main.tf
    variables.tf
    outputs.tf

  dev/main.tf:
    module "app" { source = "../modules/app"; env = "dev" }

  staging/main.tf:
    module "app" { source = "../modules/app"; env = "staging" }

  production/main.tf:
    module "app" { source = "../modules/app"; env = "production" }

  Исправил в modules/app -> работает везде сразу.
EOF
```{{execute}}

## Типы источников модулей

```bash
cat << 'EOF'
source = "..."  может быть:

  "./modules/app"              локальная папка (относительный путь)
  "../shared/modules/vpc"      локальная папка (выше по дереву)

  "hashicorp/consul/aws"       Terraform Registry (официальный)
  "app.terraform.io/org/name"  Terraform Cloud Registry (приватный)

  "git::https://github.com/org/repo.git"         Git (HTTPS)
  "git::ssh://github.com/org/repo.git"           Git (SSH)
  "git::https://github.com/org/repo.git?ref=v1"  Git с тегом

  "github.com/org/repo"        GitHub (сокращённая форма)
  "bitbucket.org/org/repo"     Bitbucket

  "s3::https://s3.amazonaws.com/bucket/module.zip"  S3
EOF
```{{execute}}

## Структура модуля

```bash
cat << 'EOF'
Минимальный модуль:
  modules/my-module/
    main.tf         <- ресурсы
    variables.tf    <- входные переменные
    outputs.tf      <- что отдаём наружу

Рекомендуемая структура:
  modules/my-module/
    main.tf         <- основные ресурсы
    variables.tf    <- все input переменные
    outputs.tf      <- все output значения
    versions.tf     <- required_providers (без backend!)
    README.md       <- документация (для реестра — обязательно)
    examples/       <- примеры использования
      basic/
        main.tf
EOF
```{{execute}}
