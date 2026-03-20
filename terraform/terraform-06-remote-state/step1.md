# Шаг 1: Установка Terraform + MinIO в Docker

```bash
apt-get update -qq && apt-get install -y -qq gnupg curl jq
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor   -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]   https://apt.releases.hashicorp.com $(lsb_release -cs) main"   | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -qq && apt-get install -y terraform
terraform version
```{{execute}}

## Поднимаем MinIO — S3 в Docker

```bash
docker run -d   --name minio   -p 9000:9000   -p 9001:9001   -e MINIO_ROOT_USER=minioadmin   -e MINIO_ROOT_PASSWORD=minioadmin   quay.io/minio/minio server /data --console-address ":9001"
```{{execute}}

```bash
# Ждём запуска
sleep 3
docker ps | grep minio
curl -sf http://localhost:9000/minio/health/live && echo "MinIO: OK"
```{{execute}}

## Устанавливаем mc (MinIO Client)

```bash
curl -sf https://dl.min.io/client/mc/release/linux-amd64/mc   -o /usr/local/bin/mc && chmod +x /usr/local/bin/mc
mc alias set local http://localhost:9000 minioadmin minioadmin
mc --version
```{{execute}}

## Создаём bucket для Terraform state

```bash
# Создаём bucket
mc mb local/terraform-state
```{{execute}}

```bash
# Включаем версионирование (история state!)
mc version enable local/terraform-state
mc version info local/terraform-state
```{{execute}}

```bash
# Смотрим что создалось
mc ls local/
```{{execute}}

```bash
cat << 'EOF'
MinIO настроен:
  Endpoint:   http://localhost:9000
  Console:    http://localhost:9001
  Access Key: minioadmin
  Secret Key: minioadmin
  Bucket:     terraform-state

В реальном проекте:
  AWS S3:               s3://bucket-name
  Yandex Object Storage: https://storage.yandexcloud.net
  GCS:                  gs://bucket-name
  Azure Blob:           azurerm backend
EOF
```{{execute}}
