# Шаг 8: terraform.tfstate.backup и восстановление

## Автоматические резервные копии

```bash
cd ~/tf-state
ls -la *.tfstate* 2>/dev/null || echo "Нет backup файлов"
```{{execute}}

```bash
# Делаем несколько apply чтобы появился backup
terraform apply -auto-approve
ls -la *.tfstate*
```{{execute}}

```bash
cat << 'EOF'
Правила резервных копий:

  terraform.tfstate         текущий state
  terraform.tfstate.backup  предыдущая версия (один шаг назад)

  При каждом успешном apply:
    1. terraform.tfstate -> terraform.tfstate.backup
    2. Новый state -> terraform.tfstate

  Только ОДНА резервная копия — не история версий!
  Для настоящей истории нужен remote backend с версионированием.
EOF
```{{execute}}

## Serial как защита от конфликтов

```bash
cat terraform.tfstate | jq '.serial'
cat terraform.tfstate.backup | jq '.serial'
```{{execute}}

```bash
cat << 'EOF'
Serial — счётчик версий state:

  При каждом apply: serial++
  При merge конфликтов: Terraform проверяет serial

  Сценарий конфликта:
    Исходный serial: 5
    Разработчик А делает apply -> serial = 6 (записывает)
    Разработчик Б делает apply -> его локальная копия serial=5
    Б пытается записать state с serial=6...
    Terraform видит: ожидается 6, получено 6, но lineage совпадает
    -> КОНФЛИКТ! Нужен force-push или ручное разрешение
EOF
```{{execute}}

## Восстановление из backup

```bash
cat << 'EOF'
Как восстановить state:

  # Из backup (один шаг назад):
  cp terraform.tfstate.backup terraform.tfstate
  terraform plan  # проверяем что state корректен

  # Из remote backend (если было версионирование S3):
  aws s3 cp s3://bucket/key/terraform.tfstate .
  # Выбрать нужную версию через S3 versioning

  # Пересоздать state с нуля (экстремальный случай):
  rm terraform.tfstate
  terraform import resource.name REAL_ID  # для каждого ресурса
EOF
```{{execute}}

```bash
# Демонстрация: портим state и восстанавливаем
cp terraform.tfstate terraform.tfstate.manual_backup
echo '{}' > terraform.tfstate   # сломали state
terraform plan 2>&1 | head -5   # Terraform запутался
```{{execute}}

```bash
# Восстанавливаем из backup
cp terraform.tfstate.manual_backup terraform.tfstate
terraform plan | tail -3
echo "State восстановлен!"
```{{execute}}
