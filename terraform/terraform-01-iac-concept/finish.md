# Урок завершён!

## Что изучили

- **ClickOps vs IaC** -- почему руками плохо и чем лучше код
- **Декларативность** -- описываем ЧТО хотим, Terraform разбирается КАК
- **HCL синтаксис** -- блоки, аргументы, метки, интерполяция `${}`
- **Провайдеры** -- плагины для AWS, GCP, Docker, Kubernetes; `required_providers`
- **`terraform init`** -- скачать провайдеры, инициализировать проект
- **`terraform plan`** -- dry-run: показать изменения без применения
- **`terraform apply`** -- применить изменения; `-auto-approve` для CI/CD
- **`terraform destroy`** -- удалить все ресурсы
- **Структура проекта** -- `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`
- **Workflow** -- fmt → validate → plan → apply → commit

## Шпаргалка команд

```bash
terraform init              # скачать провайдеры, инициализировать
terraform fmt               # форматировать .tf файлы
terraform validate          # проверить синтаксис
terraform plan              # показать план изменений
terraform plan -out=tfplan  # сохранить план в файл
terraform apply             # применить (с подтверждением)
terraform apply -auto-approve          # без подтверждения
terraform apply tfplan                 # применить сохранённый план
terraform destroy -auto-approve        # удалить всё
terraform output                       # показать outputs
terraform state list                   # список ресурсов в state
terraform show                         # детали текущего state
```

## Следующий урок

**Урок 2** — Первые ресурсы: провайдер `local` во всех деталях,
`resource`, `data`, связи между ресурсами, ссылки на атрибуты.
