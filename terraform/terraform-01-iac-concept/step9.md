# Шаг 9: Terraform Registry и экосистема

## Terraform Registry

```bash
cat << 'EOF'
registry.terraform.io — официальный реестр:

  Провайдеры   registry.terraform.io/hashicorp/aws
               registry.terraform.io/yandex-cloud/yandex
               Установка: terraform init скачивает автоматически

  Модули       registry.terraform.io/terraform-aws-modules/vpc/aws
               Готовые конфигурации для переиспользования
               Установка: указать source в блоке module {}

Версионирование:
  Провайдеры и модули версионируются через Git теги
  Всегда фиксируйте версии в конфиге!
EOF
```{{execute}}

## Terraform workflow в команде

```bash
cat << 'EOF'
Типичный рабочий процесс:

  Разработчик:
    1. git clone / git pull
    2. terraform init          (скачать провайдеры)
    3. Редактировать .tf файлы
    4. terraform fmt           (форматировать код)
    5. terraform validate      (проверить синтаксис)
    6. terraform plan          (посмотреть что изменится)
    7. git commit + push
    8. Pull Request → Code Review

  CI/CD pipeline:
    9. terraform plan -out=tfplan   (план в артефакт)
   10. Ожидание одобрения
   11. terraform apply tfplan       (применить)

  Продакшен:
    12. Изменения только через Git (GitOps)
    13. Никогда не делать terraform apply руками!
EOF
```{{execute}}

## Полезные команды

```bash
cat << 'EOF'
terraform fmt          форматировать .tf файлы (как gofmt)
terraform validate     проверить синтаксис и логику конфига
terraform show         показать текущий state или сохранённый план
terraform output       показать значения output
terraform state list   список ресурсов в state
terraform state show   подробности о ресурсе из state
terraform import       импортировать существующий ресурс в state
terraform taint        пометить ресурс для пересоздания (устарело в 1.x)
terraform refresh      синхронизировать state с реальностью
terraform console      интерактивная консоль для выражений HCL
EOF
```{{execute}}

```bash
# terraform fmt — форматирование кода
cd ~/terraform-project
terraform fmt
echo "Код отформатирован"
```{{execute}}

```bash
# terraform validate — проверка синтаксиса
terraform validate
```{{execute}}

```bash
# terraform console — вычислить выражение HCL
echo '"hello" == "hello"' | terraform console 2>/dev/null || echo "console требует инициализации"
cd ~/terraform-project && terraform init -upgrade 2>&1 | tail -3
echo '"hello world" | upper' | terraform console 2>/dev/null || true
```{{execute}}
