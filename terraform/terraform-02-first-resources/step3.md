# Шаг 3: local_sensitive_file — файлы с секретами

`local_sensitive_file` работает как `local_file`, но **содержимое скрыто**
в выводе `terraform plan`, `terraform show` и в state-файле (зашифровано).

## Зачем это нужно

```bash
cat << 'EOF'
Проблема с local_file для секретов:
  $ terraform show
  # local_file.password:
  resource "local_file" "password" {
    content  = "MyS3cr3tPassw0rd!"   <- ВИДЕН ВСЕМ!
    filename = "/tmp/db.password"
  }

С local_sensitive_file:
  $ terraform show
  # local_sensitive_file.password:
  resource "local_sensitive_file" "password" {
    content  = (sensitive value)     <- скрыто
    filename = "/tmp/db.password"
  }
EOF
```{{execute}}

## Пример использования

```bash
cd ~/tf-resources

cat >> main.tf << 'EOF'

# Файл с паролем — содержимое скрыто в логах
resource "local_sensitive_file" "db_password" {
  content         = "SuperSecret_DB_Pass_2024!"
  filename        = "/tmp/tf-demo/db.password"
  file_permission = "0600"    # rw------- только владелец
}

# SSH private key — тоже sensitive
resource "local_sensitive_file" "ssh_key" {
  content         = <<-KEY
    -----BEGIN OPENSSH PRIVATE KEY-----
    (это демо — не настоящий ключ)
    -----END OPENSSH PRIVATE KEY-----
  KEY
  filename        = "/tmp/tf-demo/id_rsa"
  file_permission = "0600"
}
EOF
```{{execute}}

```bash
# В plan содержимое скрыто
terraform plan
```{{execute}}

```bash
terraform apply -auto-approve
```{{execute}}

```bash
# Файл создан с правами 0600
ls -la /tmp/tf-demo/db.password /tmp/tf-demo/id_rsa
```{{execute}}

```bash
# terraform show тоже скрывает
terraform state show local_sensitive_file.db_password
```{{execute}}

## Сравнение: sensitive vs обычный в state

```bash
# В state-файле sensitive тоже скрыт
cat terraform.tfstate | python3 -m json.tool | grep -A3 '"db_password"' | head -10
```{{execute}}
