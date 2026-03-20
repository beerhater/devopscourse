# Шаг 4: terraform plan — читаем вывод

`plan` — самая важная команда для понимания что произойдёт.
Разбираем вывод детально.

## Запускаем plan и читаем вывод

```bash
cd ~/tf-commands
terraform plan
```{{execute}}

```bash
cat << 'EOF'
Символы изменений:
  +  create    <- ресурс будет СОЗДАН (зелёный)
  -  destroy   <- ресурс будет УДАЛЁН (красный)
  ~  update    <- ресурс будет ОБНОВЛЁН на месте (жёлтый/оранжевый)
  -/+ replace  <- УДАЛИТЬ и ПЕРЕСОЗДАТЬ (красный + зелёный)
  <= read      <- data source будет прочитан

Атрибуты:
  (known after apply)  <- значение неизвестно до apply (напр. random_id.hex)
  (sensitive value)    <- sensitive атрибут
  # forces replacement <- это изменение требует пересоздания ресурса

Итог:
  Plan: X to add, Y to change, Z to destroy.
EOF
```{{execute}}

## Флаги terraform plan

```bash
cat << 'EOF'
terraform plan [флаги]

  -out=tfplan          сохранить план в файл (для apply tfplan)
  -var="key=value"     передать переменную
  -var-file="file"     файл с переменными
  -target=ADDR         только конкретный ресурс (resource.name)
  -destroy             план для destroy (что будет удалено)
  -refresh=false       не обновлять state из реального состояния
  -refresh-only        только обновить state, не планировать изменения
  -parallelism=N       параллельность (default: 10)
  -compact-warnings    сжатые предупреждения
  -no-color            без цвета (для CI логов)
  -json                вывод в JSON
  -input=false         не спрашивать переменные интерактивно
EOF
```{{execute}}

## -out: сохраняем план для apply

```bash
# Сохраняем план в файл
terraform plan -out=tfplan
```{{execute}}

```bash
ls -la tfplan
```{{execute}}

```bash
# Посмотреть содержимое сохранённого плана
terraform show tfplan
```{{execute}}

## -var: передаём переменные

```bash
# Переопределяем переменные прямо в командной строке
terraform plan -var="env=production" -var="name=my-app"
```{{execute}}

## -target: только конкретный ресурс

```bash
# Планируем изменения только для одного ресурса
terraform plan -target=local_file.config
```{{execute}}

```bash
# -target для data sources
terraform plan -target=random_id.id
```{{execute}}

## -destroy: план удаления

```bash
# Посмотреть что будет удалено при destroy
terraform plan -destroy
```{{execute}}
