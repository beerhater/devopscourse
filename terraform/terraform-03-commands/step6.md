# Шаг 6: terraform destroy

```bash
cd ~/tf-commands
```{{execute}}

## Просмотр перед удалением

```bash
# Всегда сначала смотрим что будет удалено
terraform plan -destroy
```{{execute}}

## Флаги terraform destroy

```bash
cat << 'EOF'
terraform destroy [флаги]

  -auto-approve     не спрашивать подтверждения
  -target=ADDR      удалить только конкретный ресурс
  -var="key=val"    переменные (если нужны для вычисления ресурсов)
  -var-file="file"  файл переменных
  -no-color         без цвета

terraform destroy == terraform apply -destroy
  (это буквально алиас)
EOF
```{{execute}}

## Удаление конкретного ресурса через -target

```bash
# Посмотреть все ресурсы в state
terraform state list
```{{execute}}

```bash
# Удалить только config файл, оставить random_id
terraform destroy -auto-approve -target=local_file.config
```{{execute}}

```bash
# random_id всё ещё в state
terraform state list
```{{execute}}

```bash
# Восстанавливаем удалённый ресурс
terraform apply -auto-approve
```{{execute}}

## Полное уничтожение

```bash
terraform destroy -auto-approve
```{{execute}}

```bash
# State теперь пустой
cat terraform.tfstate
```{{execute}}

```bash
# Файлы удалены
ls /tmp/tf-cmds/ 2>/dev/null && echo "есть файлы" || echo "директория пуста или удалена"
```{{execute}}

## destroy vs rm файлов вручную

```bash
cat << 'EOF'
ЧТО БУДЕТ если удалить файл руками, без terraform destroy?

  1. Terraform не знает что файл пропал
  2. State всё ещё содержит запись о файле
  3. При следующем terraform plan:
     "Note: Objects have changed outside of Terraform"
     Terraform покажет drift (расхождение) и предложит пересоздать

  Правило: ВСЕГДА удаляйте ресурсы через terraform destroy
  Только так state остаётся консистентным.
EOF
```{{execute}}

```bash
# Демонстрация drift
terraform apply -auto-approve
rm -f /tmp/tf-cmds/cr-it-dev.conf
terraform plan   # покажет: must be replaced
```{{execute}}
