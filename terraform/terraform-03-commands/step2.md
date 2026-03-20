# Шаг 2: terraform init — во всех деталях

`terraform init` — обязательно первым делом в любом проекте.
Разберём все флаги и сценарии.

## Базовый init

```bash
cd ~/tf-commands
terraform init
```{{execute}}

```bash
cat << 'EOF'
Что создаёт terraform init:

  .terraform/
  └── providers/
      └── registry.terraform.io/
          ├── hashicorp/local/2.x.x/linux_amd64/
          └── hashicorp/random/3.x.x/linux_amd64/

  .terraform.lock.hcl   <- lock-файл с точными версиями и хешами

terraform init безопасно запускать повторно — идемпотентен.
EOF
```{{execute}}

## Флаги terraform init

```bash
cat << 'EOF'
terraform init [флаги]

  -upgrade              обновить провайдеры до последних версий (в рамках constraints)
  -reconfigure          сбросить backend конфигурацию (не мигрировать state)
  -migrate-state        мигрировать state при смене backend
  -backend=false        не инициализировать backend (только провайдеры)
  -get=false            не скачивать провайдеры/модули
  -input=false          не задавать вопросов (для CI/CD)
  -no-color             без цветного вывода (для логов)
  -lockfile=readonly    не обновлять .terraform.lock.hcl
  -plugin-dir=PATH      брать провайдеры из локальной директории (offline)
EOF
```{{execute}}

## terraform init -upgrade

```bash
# Обновить провайдеры до последних версий в рамках constraints
terraform init -upgrade
```{{execute}}

## Что делать если .terraform потёрт

```bash
# Симулируем потерю .terraform/
rm -rf .terraform
ls -la
```{{execute}}

```bash
# Просто запускаем init заново — всё восстановится
terraform init
ls .terraform/providers/registry.terraform.io/hashicorp/
```{{execute}}

## .terraform.lock.hcl — зачем и как использовать

```bash
cat .terraform.lock.hcl
```{{execute}}

```bash
cat << 'EOF'
.terraform.lock.hcl содержит:
  provider "registry.terraform.io/hashicorp/local" {
    version     = "2.x.x"             <- точная версия
    constraints = "~> 2.4"            <- constraints из required_providers
    hashes = [
      "h1:...",                        <- хеш для проверки подлинности
      "zh:...",                        <- хеш по алгоритму zh
    ]
  }

КОММИТИТЬ в Git: ДА — гарантирует воспроизводимость
ИЗМЕНЯТЬ руками: НЕТ — только через terraform init -upgrade
EOF
```{{execute}}
