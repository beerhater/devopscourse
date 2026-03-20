# Шаг 2: Структура terraform.tfstate — разбираем JSON

State файл — обычный JSON. Разберём каждое поле.

## Смотрим tfstate целиком

```bash
cd ~/tf-state
cat terraform.tfstate
```{{execute}}

```bash
# Форматированный вывод
cat terraform.tfstate | jq .
```{{execute}}

## Разбираем структуру

```bash
# Версия формата state и serial (счётчик изменений)
cat terraform.tfstate | jq '{version, terraform_version, serial, lineage}'
```{{execute}}

```bash
cat << 'EOF'
Поля верхнего уровня:

  version           версия формата state (сейчас 4)
  terraform_version версия Terraform которая создала state
  serial            счётчик: растёт при каждом apply
                    используется для обнаружения конфликтов
  lineage           UUID уникальный для этого state
                    защита от перепутывания state-файлов
  outputs           сохранённые output значения
  resources         массив всех ресурсов под управлением
EOF
```{{execute}}

## Ресурсы в state

```bash
# Список ресурсов
cat terraform.tfstate | jq '.resources[].type + "." + .resources[].name'
```{{execute}}

```bash
# Детали конкретного ресурса
cat terraform.tfstate | jq '.resources[] | select(.type == "local_file")'
```{{execute}}

```bash
cat << 'EOF'
Каждый ресурс в state содержит:

  mode       "managed" (resource) или "data" (data source)
  type       тип ресурса: "local_file", "aws_instance", ...
  name       имя из .tf: "server_config"
  provider   провайдер: "provider["registry.../hashicorp/local"]"
  instances  массив экземпляров ресурса (обычно один)
    schema_version  версия схемы провайдера
    attributes      ВСЕ атрибуты ресурса (включая sensitive!)
    sensitive_attributes  список sensitive атрибутов
    dependencies    зависимости от других ресурсов
EOF
```{{execute}}

## Атрибуты ресурса в state

```bash
# Все атрибуты local_file
cat terraform.tfstate | jq '.resources[] | select(.type == "local_file") | .instances[].attributes'
```{{execute}}

```bash
# Атрибуты random_password — пароль виден в открытом виде!
cat terraform.tfstate | jq '.resources[] | select(.type == "random_password") | .instances[].attributes'
```{{execute}}

```bash
# Serial растёт с каждым apply
echo "Текущий serial: $(cat terraform.tfstate | jq .serial)"
terraform apply -auto-approve
echo "После apply serial: $(cat terraform.tfstate | jq .serial)"
```{{execute}}
