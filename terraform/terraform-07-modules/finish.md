# Terraform-курс завершён! 

## Что изучили в уроке 7

- **Зачем модули** -- DRY принцип; один баг-фикс работает во всех окружениях
- **Структура модуля** -- `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`
- **`module` блок** -- `source`, `version`; ссылки `module.NAME.OUTPUT`
- **Вложенные модули** -- output одного = input другого; граф зависимостей
- **`for_each` с модулями** -- N экземпляров из map; адресация `module.app["dev"]`
- **Публичный реестр** -- registry.terraform.io; Verified модули; version constraints
- **Git source** -- `git::https://...?ref=v1.2`; приватные репозитории
- **`providers` в модулях** -- `configuration_aliases`; мультирегионные деплои
- **Best practices** -- семантическое версионирование, документация, validation, примеры

## Весь Terraform-курс: что освоили

| Урок | Тема |
|------|------|
| 1 | Что такое IaC, установка, первый `terraform apply` |
| 2 | Провайдер `local`, первые ресурсы, `resource` блок |
| 3 | Основные команды: `init`, `fmt`, `validate`, `plan`, `apply`, `destroy` |
| 4 | `variable`, `output`, типы, валидация, `tfvars`, `locals`, `for` |
| 5 | State-файл: структура, drift, `state` команды, sensitive, locking |
| 6 | Remote State: MinIO/S3 backend, workspace, `terraform_remote_state` |
| 7 | Модули: local, registry, git, `for_each`, providers, best practices |

## Что дальше?

```
Следующие шаги после курса:

  Реальные провайдеры:
    AWS / Yandex Cloud / GCP / Azure

  Продвинутые темы:
    Terragrunt       <- обёртка над Terraform (DRY для backends и модулей)
    Terratest        <- Go-тесты для Terraform модулей
    Checkov          <- статический анализ безопасности
    Infracost        <- оценка стоимости до apply
    OpenTofu         <- open-source fork Terraform

  CI/CD интеграция:
    GitHub Actions + Terraform Cloud
    GitLab CI + S3 backend
    atlantis         <- GitOps для Terraform
```
