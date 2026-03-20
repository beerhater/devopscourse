# Шаг 2: resource "local_file" — все аргументы

`local_file` — главный ресурс провайдера. Создаёт файл с заданным содержимым.

## Аргументы local_file

```bash
cat << 'EOF'
Аргументы (все, кроме filename, опциональны):

  СОДЕРЖИМОЕ (одно из трёх — обязательно):
    content              строка (обычный текст, HCL-строки)
    content_base64       бинарный контент закодированный в base64
    source               путь к файлу-источнику (скопировать как есть)

  ПУТЬ:
    filename             ОБЯЗАТЕЛЬНЫЙ — полный путь к создаваемому файлу

  ПРАВА:
    file_permission      права на файл (default: "0777")
    directory_permission права на создаваемые директории (default: "0777")

  COMPUTED (только для чтения — атрибуты которые Terraform заполняет сам):
    id                   SHA1-хеш содержимого файла
    content_md5          MD5 содержимого
    content_sha256       SHA256 содержимого
    content_sha512       SHA512 содержимого
    content_base64sha256 base64(SHA256) содержимого
EOF
```{{execute}}

## Примеры всех способов задать содержимое

```bash
cd ~/tf-resources
cat > main.tf << 'EOF'
# 1. Простая строка
resource "local_file" "simple" {
  content  = "Привет, это простой файл!
"
  filename = "/tmp/tf-demo/simple.txt"
  file_permission = "0644"
}

# 2. Многострочная строка через heredoc
resource "local_file" "multiline" {
  content  = <<-EOT
    Строка 1
    Строка 2
    Строка 3
  EOT
  filename        = "/tmp/tf-demo/multiline.txt"
  file_permission = "0644"
}

# 3. Heredoc без лишних отступов (<<-EOT обрезает ведущие пробелы)
resource "local_file" "config" {
  content = <<-CONFIG
    [server]
    host = localhost
    port = 8080
    debug = false
  CONFIG
  filename        = "/tmp/tf-demo/app.conf"
  file_permission = "0640"    # rw-r-----
  directory_permission = "0755"
}

# 4. Копирование из файла-источника
resource "local_file" "copy_source" {
  source   = "/etc/hostname"    # читает реальный файл с диска
  filename = "/tmp/tf-demo/hostname-copy.txt"
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
# Проверяем созданные файлы
ls -la /tmp/tf-demo/
echo "--- simple.txt ---"
cat /tmp/tf-demo/simple.txt
echo "--- app.conf ---"
cat /tmp/tf-demo/app.conf
echo "--- hostname-copy.txt ---"
cat /tmp/tf-demo/hostname-copy.txt
```{{execute}}

## Атрибуты, которые Terraform вычисляет сам

```bash
# Посмотреть вычисленные атрибуты
terraform state show local_file.config
```{{execute}}
