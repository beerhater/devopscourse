# Шаг 7: Модули из Git и структура реального проекта

## Git как источник модулей

```bash
cat << 'EOF'
source = "git::https://github.com/org/terraform-modules.git//modules/vpc"
                                                            ^^
                                                     двойной // = поддиректория

Форматы:
  "git::https://github.com/org/repo.git"           ветка main/master
  "git::https://github.com/org/repo.git?ref=v1.2"  тег v1.2
  "git::https://github.com/org/repo.git?ref=main"  ветка main
  "git::ssh://git@github.com/org/repo.git?ref=v1"  SSH

  "github.com/org/repo"                            сокращение для GitHub
  "github.com/org/repo//modules/vpc?ref=v2.0"      поддиректория + тег

Для приватных репозиториев:
  - SSH: настроить SSH ключ
  - HTTPS: Git credential helper или token в URL
  - GitHub Actions: actions/checkout + ssh-agent
EOF
```{{execute}}

## Структура production проекта

```bash
cat << 'EOF'
Рекомендуемая структура Terraform проекта:

  terraform/
  ├── modules/                     <- переиспользуемые модули
  │   ├── app-service/
  │   │   ├── main.tf
  │   │   ├── variables.tf
  │   │   ├── outputs.tf
  │   │   ├── versions.tf
  │   │   └── README.md
  │   ├── database/
  │   └── networking/
  │
  ├── environments/                <- окружения
  │   ├── dev/
  │   │   ├── main.tf              <- module { source = "../../modules/..." }
  │   │   ├── terraform.tfvars
  │   │   └── backend.hcl
  │   ├── staging/
  │   └── production/
  │
  └── shared/                      <- общий state (networking, dns)
      ├── main.tf
      └── outputs.tf

Или монорепо с Terragrunt:
  infra/
  ├── _modules/
  ├── dev/
  │   ├── terragrunt.hcl
  │   └── app/
  │       └── terragrunt.hcl
  └── prod/
      └── app/
          └── terragrunt.hcl
EOF
```{{execute}}

## terraform-docs — автодокументация модулей

```bash
cat << 'EOF'
terraform-docs — генерирует README из variables.tf и outputs.tf

  Установка:
    curl -sfL https://github.com/terraform-docs/terraform-docs/releases/      download/v0.17.0/terraform-docs-v0.17.0-linux-amd64.tar.gz | tar -xz
    mv terraform-docs /usr/local/bin/

  Использование:
    terraform-docs markdown table ./modules/app-config
    terraform-docs markdown table ./modules/app-config > README.md

  Пример вывода в README:
    ## Inputs
    | Name | Description | Type | Default | Required |
    |------|-------------|------|---------|:--------:|
    | project | Название проекта | string | n/a | yes |
    | environment | Окружение | string | n/a | yes |

    ## Outputs
    | Name | Description |
    |------|-------------|
    | deploy_id | Уникальный ID деплоя |
    | config_path | Путь к файлу конфигурации |

  В CI/CD (pre-commit hook):
    - repo: https://github.com/terraform-docs/terraform-docs
      hooks:
        - id: terraform-docs-go
          args: ["markdown", "table", "--output-file", "README.md", "."]
EOF
```{{execute}}

## terraform get — скачать модули без init

```bash
cat << 'EOF'
terraform get [флаги]

  Скачивает модули в .terraform/modules/ без инициализации провайдеров.

  terraform get           <- скачать новые/обновлённые модули
  terraform get -update   <- обновить уже скачанные модули

  terraform init автоматически вызывает terraform get.
  Отдельно нужен редко — только если добавили новый module {} блок
  и не хочешь полный init.
EOF
```{{execute}}
