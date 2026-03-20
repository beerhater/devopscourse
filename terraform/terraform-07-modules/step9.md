# Шаг 9: Тестирование модулей и best practices

## module -target и модульные операции

```bash
cd ~/tf-modules
```{{execute}}

```bash
# Применить только один модуль
terraform apply -target=module.app["api"] -auto-approve
```{{execute}}

```bash
# Пересоздать конкретный ресурс внутри модуля
terraform apply -replace=module.app["api"].random_id.deploy_id -auto-approve
```{{execute}}

```bash
# State для модулей
terraform state list | grep 'module\.'
```{{execute}}

```bash
# show конкретного ресурса модуля
terraform state show 'module.app["api"].local_file.app_config'
```{{execute}}

## Best practices для модулей

```bash
cat << 'EOF'
1. СЕМАНТИЧЕСКОЕ ВЕРСИОНИРОВАНИЕ
   Тег каждый релиз: v1.0.0, v1.1.0, v2.0.0
   source = "git::https://github.com/org/modules.git?ref=v1.2.0"

2. ДОКУМЕНТИРУЙ INPUTS и OUTPUTS
   description в каждом variable и output
   terraform-docs для автогенерации README

3. ВАЛИДАЦИЯ INPUTS
   validation {} блок в каждой критичной переменной
   Лучше упасть при init чем создать сломанный ресурс

4. НЕТ BACKEND В МОДУЛЕ
   backend {} — только в root module
   Модуль не знает где хранится state

5. НЕТ PROVIDER В МОДУЛЕ (обычно)
   Провайдеры конфигурируются в root module
   Исключение: configuration_aliases для мультирегиона

6. МИНИМАЛЬНЫЕ ПРИВИЛЕГИИ
   Модуль должен просить только то что нужно
   Не принимать весь конфиг провайдера

7. ПРИМЕРЫ В examples/
   examples/basic/       <- минимальный пример
   examples/complete/    <- все параметры
   Примеры = тесты что модуль работает

8. ОДНА ОТВЕТСТВЕННОСТЬ
   Модуль "vpc" создаёт только сеть
   Модуль "app" создаёт только приложение
   Не делай God Module на всё
EOF
```{{execute}}

## terraform-docs симуляция

```bash
# Имитируем вывод terraform-docs для нашего модуля
cat << 'EOF'
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| local | ~> 2.4 |
| random | ~> 3.4 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | Название проекта | `string` | n/a | yes |
| environment | Окружение: dev, staging, production | `string` | n/a | yes |
| app\_port | Порт приложения | `number` | `8080` | no |
| output\_dir | Директория для конфигов | `string` | `"/tmp/modules-demo"` | no |
| extra\_env\_vars | Дополнительные переменные окружения | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| deploy\_id | Уникальный ID деплоя |
| config\_path | Путь к файлу конфигурации |
| env\_path | Путь к .env файлу |
| app\_name | Полное имя приложения |
EOF
```{{execute}}
