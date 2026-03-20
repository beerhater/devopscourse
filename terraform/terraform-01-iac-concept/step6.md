# Шаг 6: terraform plan

`terraform plan` показывает что Terraform **собирается сделать**, не применяя изменения.
Это dry-run: аналог `ansible-playbook --check`.

## Запускаем plan

```bash
cd ~/terraform-intro
terraform plan
```{{execute}}

## Читаем вывод plan

```bash
cat << 'EOF'
Terraform покажет три типа действий:

  + create    ← создать новый ресурс (зелёный)
  ~ update    ← обновить существующий ресурс на месте (жёлтый)
  - destroy   ← удалить ресурс (красный)
  -/+ replace ← удалить и пересоздать (красно-зелёный)

В конце: Plan: X to add, Y to change, Z to destroy.

Правило: ВСЕГДА читайте plan перед apply.
Особенно смотрите на -/+ replace — это пересоздание ресурса.
В облаке это значит: EC2 будет удалён и создан новый (downtime!).
EOF
```{{execute}}

## Сохранение plan в файл

```bash
# Сохранить план — гарантирует что apply выполнит именно этот план
terraform plan -out=tfplan
```{{execute}}

```bash
ls -la tfplan
```{{execute}}

```bash
# Посмотреть сохранённый план в читаемом виде
terraform show tfplan
```{{execute}}

## Plan и безопасность

```bash
cat << 'EOF'
В команде:
  terraform plan -out=tfplan   # сохранить план
  terraform apply tfplan       # применить ТОЧНО этот план

Так работают в production:
  1. terraform plan -out=tfplan     (в CI/CD pipeline)
  2. Code review плана (человек одобряет)
  3. terraform apply tfplan         (только после одобрения)

  Это гарантирует что apply не сделает ничего лишнего.
EOF
```{{execute}}
