# Шаг 5: Версионирование State — история изменений

## Версионирование в MinIO bucket

```bash
# У нас уже включено версионирование
mc version info local/terraform-state
```{{execute}}

```bash
cd ~/tf-remote
```{{execute}}

```bash
# Делаем несколько apply — каждый создаёт версию в bucket
terraform apply -auto-approve -var="env=dev"
sleep 1
terraform apply -auto-approve -var="env=dev"
sleep 1
terraform apply -auto-approve -var="env=dev"
```{{execute}}

```bash
# Смотрим версии state файла в MinIO
mc ls --versions local/terraform-state/dev/
```{{execute}}

```bash
cat << 'EOF'
Версионирование даёт:
  - Историю всех изменений state
  - Возможность откатить state на любую версию
  - Защита от случайного удаления (soft delete)

В AWS S3:
  Включить: aws s3api put-bucket-versioning     --bucket my-terraform-state     --versioning-configuration Status=Enabled

  Посмотреть версии:
    aws s3api list-object-versions       --bucket my-terraform-state       --prefix prod/terraform.tfstate

  Восстановить версию:
    aws s3api get-object       --bucket my-terraform-state       --key prod/terraform.tfstate       --version-id VERSION_ID       terraform.tfstate.restored
EOF
```{{execute}}

## Восстановление конкретной версии

```bash
# Получить конкретную версию (берём VersionID из вывода ls --versions)
VERSION_ID=$(mc ls --versions local/terraform-state/dev/ --json   | jq -r 'select(.versionID != null) | .versionID' | head -1)
echo "Первая версия: $VERSION_ID"
```{{execute}}

```bash
# Скачать конкретную версию
mc get --version-id "$VERSION_ID"   local/terraform-state/dev/terraform.tfstate   /tmp/old_state.json 2>/dev/null &&   cat /tmp/old_state.json | jq '.serial' &&   echo "Версия скачана успешно"
```{{execute}}

```bash
# Текущий serial выше
terraform state pull | jq '.serial'
```{{execute}}

```bash
cat << 'EOF'
Политика retention для state файлов:

  Рекомендации:
    - Хранить минимум 30 версий
    - Для production: хранить 90+ дней
    - S3 Lifecycle Policy: удалять версии старше 90 дней
    - Оставлять последние 10 версий всегда

  AWS S3 Lifecycle:
    aws s3api put-bucket-lifecycle-configuration       --bucket my-state       --lifecycle-configuration file://lifecycle.json
EOF
```{{execute}}
