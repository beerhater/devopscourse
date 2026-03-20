# Шаг 7: depends_on — явные зависимости

Terraform строит граф зависимостей автоматически через ссылки на атрибуты.
Но иногда зависимость есть, а ссылки нет — тогда нужен `depends_on`.

## Когда нужен depends_on

```bash
cat << 'EOF'
НЕЯВНАЯ зависимость (через ссылку — Terraform видит сам):
  resource "local_file" "b" {
    content  = local_file.a.content   <- ссылка! Terraform знает: b зависит от a
    filename = "/tmp/b.txt"
  }

ЯВНАЯ зависимость (depends_on — нужна когда связи нет в коде):
  resource "local_file" "log" {
    content  = "Лог создан после директории"
    filename = "/tmp/myapp/logs/app.log"
    depends_on = [local_file.directory_marker]  <- нет ссылки, но зависимость есть
  }

Типичные use cases для depends_on:
  - Файл нужно создать только после другого файла/директории
  - Ресурс зависит от настройки провайдера
  - Скрипт должен выполниться перед созданием ресурса
EOF
```{{execute}}

## Пример: создаём файловую структуру приложения

```bash
cd ~/tf-resources
cat > main.tf << 'EOF'
# Маркер директории (Terraform не создаёт директории напрямую)
resource "local_file" "dir_marker" {
  content  = "directory marker
"
  filename = "/tmp/myapp/.keep"
}

resource "local_file" "logs_marker" {
  content  = "logs directory marker
"
  filename = "/tmp/myapp/logs/.keep"
  depends_on = [local_file.dir_marker]
}

resource "local_file" "config_marker" {
  content  = "config directory marker
"
  filename = "/tmp/myapp/config/.keep"
  depends_on = [local_file.dir_marker]
}

# Основной конфиг — только после создания директории config
resource "local_file" "app_config" {
  content = <<-CFG
    [app]
    name = myapp
    log_dir = /tmp/myapp/logs
  CFG
  filename        = "/tmp/myapp/config/app.ini"
  file_permission = "0644"
  depends_on      = [local_file.config_marker]
}

# Лог — только после директории logs
resource "local_file" "app_log" {
  content    = "Приложение запущено
"
  filename   = "/tmp/myapp/logs/app.log"
  depends_on = [local_file.logs_marker]
}
EOF
```{{execute}}

```bash
terraform apply -auto-approve
find /tmp/myapp -type f | sort
```{{execute}}

## depends_on на модуль

```bash
cat << 'EOF'
depends_on работает и для модулей:

  module "database" {
    source = "./modules/database"
  }

  module "application" {
    source     = "./modules/application"
    depends_on = [module.database]   <- приложение после базы данных
  }
EOF
```{{execute}}
