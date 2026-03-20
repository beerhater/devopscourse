# Шаг 5: terraform state — управление state вручную

## terraform state list

```bash
cd ~/tf-state
# Все ресурсы в state
terraform state list
```{{execute}}

```bash
cat << 'EOF'
Адреса ресурсов в state:

  local_file.server_config          простой ресурс
  random_id.server_id
  random_password.db_pass

  module.vpc.aws_vpc.main           ресурс внутри модуля
  aws_instance.web[0]               count ресурс (индекс)
  aws_instance.web["prod"]          for_each ресурс (ключ)
  module.servers["web"].aws_instance.main  модуль + for_each
EOF
```{{execute}}

## terraform state show

```bash
# Все атрибуты конкретного ресурса
terraform state show local_file.server_config
```{{execute}}

```bash
terraform state show random_id.server_id
```{{execute}}

## terraform state pull и push

```bash
# pull: скачать state в stdout (для скриптов и бэкапов)
terraform state pull | jq '.serial, .lineage'
```{{execute}}

```bash
cat << 'EOF'
terraform state pull    <- прочитать state (работает и с remote backend)
terraform state push    <- записать state из файла (ОПАСНО!)

  pull полезен для:
    - Просмотра remote state без доступа к S3/GCS
    - Создания резервной копии
    - Отладки

  push опасен:
    - Перезапишет state (включая serial проверку)
    - Используй только для восстановления из бэкапа
    - Требует -force если serial не совпадает
EOF
```{{execute}}

## terraform state rm — убрать из управления

```bash
# Посмотрим что есть
terraform state list
```{{execute}}

```bash
# Убираем random_id из state (файл не удалится, Terraform забудет о нём)
terraform state rm random_id.server_id
terraform state list
```{{execute}}

```bash
# Terraform теперь хочет пересоздать random_id
terraform plan | head -15
```{{execute}}

```bash
# Восстанавливаем
terraform apply -auto-approve
terraform state list
```{{execute}}

## terraform state mv — переименование без пересоздания

```bash
cat << 'EOF'
Когда нужен state mv:

  # В .tf файле переименовали ресурс:
  # БЫЛО:  resource "local_file" "server_config" {}
  # СТАЛО: resource "local_file" "app_config" {}

  Без state mv: Terraform удалит server_config и создаст app_config
  С state mv:   Terraform переименует в state, реальный файл не тронет
EOF
```{{execute}}

```bash
# Переименовываем в state
terraform state mv local_file.server_config local_file.app_config
terraform state list
```{{execute}}

```bash
# Возвращаем обратно
terraform state mv local_file.app_config local_file.server_config
```{{execute}}
