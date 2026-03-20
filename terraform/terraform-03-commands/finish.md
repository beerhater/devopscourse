# Урок завершён!

## Что изучили

- **`terraform init`** -- `-upgrade`, `-reconfigure`, `.terraform.lock.hcl`
- **`terraform fmt`** -- форматирование, `-diff`, `-check` для CI/CD
- **`terraform validate`** -- проверка синтаксиса и схемы провайдера
- **`terraform plan`** -- чтение вывода, `-out=tfplan`, `-target`, `-var`, `-destroy`
- **`terraform apply`** -- `-auto-approve`, `apply tfplan`, `-target`, `-var-file`
- **`terraform destroy`** -- `-target`, drift detection
- **`terraform show`** -- state и планы в читаемом виде и JSON
- **`terraform state`** -- `list`, `show`, `rm`, `mv`
- **`terraform output`** -- `-raw` для bash скриптов, `-json`
- **`terraform console`** -- REPL для HCL выражений
- **tfvars приоритеты** -- default < tfvars < auto.tfvars < -var-file < -var < TF_VAR_*

## Шпаргалка команд

```bash
# Инициализация
terraform init              # первый раз
terraform init -upgrade     # обновить провайдеры

# Качество кода
terraform fmt -recursive    # форматировать
terraform validate          # проверить синтаксис

# Планирование
terraform plan                        # посмотреть изменения
terraform plan -out=tfplan            # сохранить план
terraform plan -var="env=prod"        # с переменной
terraform plan -target=resource.name  # конкретный ресурс
terraform plan -destroy               # план удаления

# Применение
terraform apply                       # с подтверждением
terraform apply -auto-approve         # без подтверждения
terraform apply tfplan                # из сохранённого плана
terraform apply -var-file=prod.tfvars

# Удаление
terraform destroy -auto-approve

# Инспекция
terraform show                    # текущий state
terraform state list              # список ресурсов
terraform state show ADDR         # детали ресурса
terraform output                  # все outputs
terraform output -raw NAME        # сырое значение для bash
terraform console                 # интерактивная консоль
```

## Следующий урок

**Урок 4** — Переменные и outputs: `variable` блок во всех деталях,
типы, валидация, `output`, `terraform.tfvars`, чувствительные outputs.
