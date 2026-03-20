# Шаг 5: Data Sources — читаем существующие файлы

`data` блоки читают уже существующие ресурсы, не создавая их.
Отличие от `resource`: data не управляет ресурсом, только читает.

## Синтаксис data

```bash
cat << 'EOF'
resource vs data:

  resource "local_file" "create" {   <- СОЗДАТЬ файл
    content  = "hello"
    filename = "/tmp/new.txt"
  }

  data "local_file" "read" {         <- ПРОЧИТАТЬ существующий файл
    filename = "/etc/hostname"
  }

  output "hostname" {
    value = data.local_file.read.content   <- использовать прочитанное
  }

Ссылка на data source:
  data.<тип>.<имя>.<атрибут>
  data.local_file.read.content
  data.local_file.read.content_base64
  data.local_file.read.id
EOF
```{{execute}}

## Пример: читаем системные файлы и генерируем отчёт

```bash
cd ~/tf-resources
cat > main.tf << 'EOF'
# Читаем существующие файлы системы
data "local_file" "hostname" {
  filename = "/etc/hostname"
}

data "local_file" "os_release" {
  filename = "/etc/os-release"
}

# Создаём файл-отчёт на основе прочитанных данных
resource "local_file" "system_report" {
  content = <<-REPORT
    ============================
    Системный отчёт
    ============================
    Хост: ${trimspace(data.local_file.hostname.content)}

    ОС информация:
    ${data.local_file.os_release.content}
    ============================
  REPORT
  filename        = "/tmp/tf-data/system_report.txt"
  file_permission = "0644"
}

# Создаём файл конфига, который включает hostname
resource "local_file" "nginx_config" {
  content = <<-NGINX
    server {
        listen 80;
        server_name ${trimspace(data.local_file.hostname.content)};
        root /var/www/html;
    }
  NGINX
  filename        = "/tmp/tf-data/nginx.conf"
  file_permission = "0644"
}
EOF
```{{execute}}

```bash
terraform plan
```{{execute}}

```bash
terraform apply -auto-approve
cat /tmp/tf-data/system_report.txt
```{{execute}}

```bash
cat /tmp/tf-data/nginx.conf
```{{execute}}

## Когда использовать data sources

```bash
cat << 'EOF'
Типичные use cases:

  data "aws_ami" "ubuntu" {...}
    <- найти последний Ubuntu AMI в AWS (не создавать, просто найти)

  data "local_file" "ssh_pubkey" {
    filename = "~/.ssh/id_rsa.pub"
  }
    <- прочитать публичный ключ и загрузить в облако

  data "terraform_remote_state" "vpc" {...}
    <- получить output другого Terraform state (cross-module)

  data "aws_secretsmanager_secret_version" "db" {...}
    <- получить секрет из AWS Secrets Manager
EOF
```{{execute}}
