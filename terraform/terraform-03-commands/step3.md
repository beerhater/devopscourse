# Шаг 3: terraform fmt и terraform validate

Два обязательных шага перед каждым `plan`.

## terraform fmt — форматирование кода

```bash
cd ~/tf-commands
```{{execute}}

```bash
# Сначала намеренно "сломаем" форматирование
cat > bad_format.tf << 'EOF'
variable "broken" {
type=string
  default =    "test"
      description="плохо отформатировано"
}

resource "local_file" "bad" {
content="test"
filename="/tmp/bad.txt"
file_permission="0644"
}
EOF
cat bad_format.tf
```{{execute}}

```bash
# terraform fmt -diff покажет что изменится (без применения)
terraform fmt -diff bad_format.tf
```{{execute}}

```bash
# terraform fmt исправляет форматирование
terraform fmt bad_format.tf
cat bad_format.tf
```{{execute}}

```bash
cat << 'EOF'
Флаги terraform fmt:

  terraform fmt              форматировать все .tf в текущей директории
  terraform fmt -recursive   рекурсивно по поддиректориям (для модулей)
  terraform fmt -diff        показать diff без применения
  terraform fmt -check       вернуть exit code 1 если нужно форматирование (CI/CD)
  terraform fmt -write=false только проверить, не писать

В CI/CD:
  terraform fmt -check -recursive || { echo "Нужно отформатировать код"; exit 1; }
EOF
```{{execute}}

```bash
rm bad_format.tf
```{{execute}}

## terraform validate — проверка синтаксиса

```bash
# Проверяем наш проект
terraform validate
```{{execute}}

```bash
# Сломаем конфиг намеренно
cat > broken.tf << 'EOF'
resource "local_file" "broken" {
  content  = "test"
  filename = "/tmp/broken.txt"
  unknown_argument = "это не существует"
}
EOF
terraform validate
```{{execute}}

```bash
rm broken.tf
terraform validate
```{{execute}}

```bash
cat << 'EOF'
terraform validate проверяет:
  ✓ Синтаксис HCL
  ✓ Обязательные аргументы
  ✓ Неизвестные аргументы
  ✓ Типы значений
  ✓ Ссылки на несуществующие ресурсы
  ✗ Не проверяет: доступность API облака, существование ресурсов

Важно: validate требует terraform init (нужны провайдеры для проверки схемы)

terraform validate -json  <- вывод в JSON (для CI/CD инструментов)
EOF
```{{execute}}
