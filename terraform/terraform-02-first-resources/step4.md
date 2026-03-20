# Шаг 4: Ссылки на атрибуты ресурсов

Ресурсы могут ссылаться на атрибуты других ресурсов.
Так Terraform строит **граф зависимостей** и определяет порядок создания.

## Синтаксис ссылки

```bash
cat << 'EOF'
<тип_ресурса>.<имя>.<атрибут>

Примеры:
  random_id.my_id.hex               <- hex значение random ID
  local_file.config.filename        <- путь к созданному файлу
  local_file.config.id              <- SHA1 содержимого
  local_file.config.content_md5     <- MD5 содержимого

Если ресурс A ссылается на атрибут ресурса B —
Terraform автоматически создаст B раньше, чем A.
Это называется неявная зависимость (implicit dependency).
EOF
```{{execute}}

## Пример: цепочка зависимых ресурсов

```bash
cd ~/tf-resources
# Начнём с чистого main.tf
cat > main.tf << 'EOF'
# 1. Генерируем случайный ID проекта
resource "random_id" "project" {
  byte_length = 6
}

# 2. Создаём файл конфига — ссылается на random_id
resource "local_file" "config" {
  content = <<-CONFIG
    project_id = ${random_id.project.hex}
    created_at = ${timestamp()}
  CONFIG
  filename        = "/tmp/tf-chain/config.ini"
  file_permission = "0644"
}

# 3. Создаём файл манифеста — ссылается на config
resource "local_file" "manifest" {
  content = <<-MANIFEST
    # Манифест проекта
    config_file = ${local_file.config.filename}
    config_hash = ${local_file.config.id}
    project_id  = ${random_id.project.hex}
  MANIFEST
  filename        = "/tmp/tf-chain/manifest.txt"
  file_permission = "0644"
}

# 4. Итоговый README — ссылается на всё
resource "local_file" "readme" {
  content  = <<-README
    # Проект ${random_id.project.hex}

    Конфиг:   ${local_file.config.filename} (md5: ${local_file.config.content_md5})
    Манифест: ${local_file.manifest.filename}
  README
  filename        = "/tmp/tf-chain/README.md"
  file_permission = "0644"
}
EOF
```{{execute}}

```bash
terraform plan
```{{execute}}

```bash
terraform apply -auto-approve
```{{execute}}

```bash
echo "--- config.ini ---"
cat /tmp/tf-chain/config.ini
echo "--- manifest.txt ---"
cat /tmp/tf-chain/manifest.txt
echo "--- README.md ---"
cat /tmp/tf-chain/README.md
```{{execute}}

## Граф зависимостей

```bash
# Terraform умеет строить визуальный граф зависимостей
terraform graph 2>/dev/null | head -20
```{{execute}}

```bash
cat << 'EOF'
Граф создания ресурсов:

  random_id.project
       ↓
  local_file.config
       ↓
  local_file.manifest
       ↓
  local_file.readme

Terraform создаст в таком порядке.
Ресурсы без зависимостей создаются параллельно.
EOF
```{{execute}}
