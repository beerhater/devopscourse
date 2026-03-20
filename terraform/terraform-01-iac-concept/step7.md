# Шаг 7: terraform apply и terraform destroy

## terraform apply — применяем изменения

```bash
cd ~/terraform-intro
terraform apply
```{{execute}}

```bash
# Terraform попросил подтверждение. Вводим yes
# Для автоматизации: terraform apply -auto-approve
```{{execute}}

```bash
# Проверяем — файлы созданы?
cat /tmp/terraform-welcome.txt
```{{execute}}

```bash
cat /tmp/terraform-random.txt
```{{execute}}

```bash
# Смотрим state-файл
ls -la terraform.tfstate
cat terraform.tfstate | head -40
```{{execute}}

## Идемпотентность apply

```bash
# Запускаем apply снова — ничего не изменится
terraform apply -auto-approve
```{{execute}}

```bash
cat << 'EOF'
Apply: No changes. Infrastructure is up-to-date.

Terraform проверяет state-файл и реальное состояние.
Если они совпадают — ничего не делает.
Это и есть идемпотентность.
EOF
```{{execute}}

## Изменение ресурса

```bash
# Меняем содержимое файла
sed -i 's/Провайдер: hashicorp\/local/Провайдер: hashicorp\/local v2/' ~/terraform-intro/main.tf
```{{execute}}

```bash
terraform plan
```{{execute}}

```bash
# Применяем изменение
terraform apply -auto-approve
cat /tmp/terraform-welcome.txt
```{{execute}}

## terraform destroy — удалить всё

```bash
# Показать что будет удалено
terraform plan -destroy
```{{execute}}

```bash
# Удалить все ресурсы
terraform destroy -auto-approve
```{{execute}}

```bash
# Файлы удалены
ls /tmp/terraform-welcome.txt 2>/dev/null || echo "файл удалён"
ls /tmp/terraform-random.txt 2>/dev/null || echo "файл удалён"
```{{execute}}

```bash
# State-файл теперь пустой
cat terraform.tfstate
```{{execute}}
