# Шаг 7: terraform show и terraform state

## terraform show

```bash
cd ~/tf-commands
terraform apply -auto-approve
```{{execute}}

```bash
# Показать текущий state в читаемом виде
terraform show
```{{execute}}

```bash
# Показать в JSON (для скриптов)
terraform show -json | python3 -m json.tool | head -40
```{{execute}}

```bash
# Показать сохранённый план
terraform plan -out=tfplan
terraform show tfplan
```{{execute}}

## terraform state list — список ресурсов

```bash
# Список всех ресурсов в state
terraform state list
```{{execute}}

```bash
cat << 'EOF'
Адрес ресурса (Resource Address):
  random_id.id
  local_file.config
  module.vpc.aws_vpc.main    <- ресурс внутри модуля
  aws_instance.web[0]        <- элемент массива (count)
  aws_instance.web["prod"]   <- элемент map (for_each)
EOF
```{{execute}}

## terraform state show — детали ресурса

```bash
# Подробная информация о конкретном ресурсе
terraform state show local_file.config
```{{execute}}

```bash
terraform state show random_id.id
```{{execute}}

## terraform state rm — удалить из state без destroy

```bash
cat << 'EOF'
terraform state rm ADDR

  Удаляет ресурс из state БЕЗ удаления реального ресурса.

  Зачем:
    - Хотим перестать управлять ресурсом через Terraform
    - Ресурс был создан не Terraform-ом, хотим перенести управление
    - Ресурс уже удалён вручную, нужно очистить state

  После state rm:
    - Terraform "забывает" о ресурсе
    - Реальный ресурс остаётся нетронутым
    - При следующем plan Terraform предложит его СОЗДАТЬ (думает что его нет)
EOF
```{{execute}}

```bash
# Убираем random_id из-под управления Terraform
terraform state rm random_id.id
```{{execute}}

```bash
# Terraform больше не знает о random_id
terraform state list
```{{execute}}

```bash
# plan предложит пересоздать random_id
terraform plan
```{{execute}}

```bash
# Восстанавливаем
terraform apply -auto-approve
```{{execute}}

## terraform state mv — переименование ресурса

```bash
cat << 'EOF'
terraform state mv СТАРЫЙ_АДРЕС НОВЫЙ_АДРЕС

  Переименовать ресурс в state без пересоздания реального ресурса.

  Зачем:
    - Переименовали ресурс в .tf файле
    - Перенесли ресурс в модуль
    - Реструктуризация кода

  Без state mv: Terraform удалит старый и создаст новый (пересоздание!)
  С state mv: только обновит state, реальный ресурс не трогает

  Пример:
    terraform state mv local_file.config local_file.app_config
EOF
```{{execute}}
