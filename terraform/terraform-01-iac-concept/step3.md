# Шаг 3: HCL — язык конфигурации Terraform

HCL (HashiCorp Configuration Language) — читаемый язык для описания инфраструктуры.
Не YAML, не JSON, не Python — свой синтаксис, специально для конфигураций.

## Базовые конструкции HCL

```bash
mkdir -p ~/terraform-intro && cd ~/terraform-intro
```{{execute}}

```bash
cat << 'EOF'
# ======================== HCL СИНТАКСИС ========================

# 1. БЛОКИ — основная единица конфигурации
#    тип_блока  "тип_ресурса"  "имя" {
#      аргумент = значение
#    }

resource "local_file" "hello" {
  content  = "Привет, Terraform!"
  filename = "/tmp/hello.txt"
}

# 2. ТИПЫ ДАННЫХ
#    Строка:  "значение"
#    Число:   42 или 3.14
#    Булево:  true / false
#    Список:  ["a", "b", "c"]
#    Объект:  { key = "value" }

# 3. ПЕРЕМЕННЫЕ
variable "имя" {
  type    = string
  default = "значение"
}

# 4. ВЫРАЖЕНИЯ И ИНТЕРПОЛЯЦИЯ
resource "local_file" "example" {
  content  = "Порт: ${var.port}"
  filename = "/tmp/${var.name}.txt"
}

# 5. OUTPUTS
output "имя_вывода" {
  value = resource.тип.имя.атрибут
}
EOF
```{{execute}}

## Создаём первый .tf файл

```bash
cat > ~/terraform-intro/main.tf << 'EOF'
# Это комментарий в HCL

# Блок terraform: настройки самого Terraform
terraform {
  required_version = ">= 1.0"
}

# Простой ресурс: создать локальный файл
resource "local_file" "welcome" {
  content  = "Привет от Terraform!
Этот файл создан декларативно."
  filename = "/tmp/terraform-welcome.txt"
}
EOF
cat ~/terraform-intro/main.tf
```{{execute}}

## Структура .tf файла

```bash
cat << 'EOF'
Каждый блок в HCL имеет:

  тип        метка1      метка2
  ──────     ──────────  ────────
  resource   "local_file" "welcome"  <- ресурс
  variable   "port"                  <- переменная (1 метка)
  output     "file_path"             <- вывод (1 метка)
  provider   "aws"                   <- провайдер (1 метка)
  terraform                          <- без меток
  module     "vpc"                   <- модуль

  Внутри блока:
    аргумент  = "значение"    <- присваивание
    вложенный_блок {          <- вложенный блок
      ...
    }
EOF
```{{execute}}
