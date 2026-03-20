# Шаг 5: terraform apply — применяем изменения

## Базовый apply с подтверждением

```bash
cd ~/tf-commands
terraform apply
```{{execute}}

```bash
# Вводим yes для подтверждения
```{{execute}}

```bash
ls -la /tmp/tf-cmds/
cat /tmp/tf-cmds/cr-it-dev.conf
```{{execute}}

## Флаги terraform apply

```bash
cat << 'EOF'
terraform apply [флаги] [план]

  -auto-approve        не спрашивать подтверждения (CI/CD)
  -var="key=value"     передать переменную
  -var-file="file"     файл с переменными
  -target=ADDR         применить только конкретный ресурс
  -parallelism=N       параллельность (default: 10)
  -refresh=false       не обновлять state из реального состояния
  -no-color            без цвета
  -input=false         не спрашивать переменные
  -compact-warnings    сжатые предупреждения
  -json                вывод в JSON (машинночитаемый формат)

  terraform apply tfplan   применить РАНЕЕ СОХРАНЁННЫЙ план
                           (игнорирует большинство флагов выше)
EOF
```{{execute}}

## apply из сохранённого плана — правильный способ в production

```bash
# Шаг 1: план с сохранением
terraform plan -out=tfplan -var="env=staging"
```{{execute}}

```bash
# Шаг 2: apply применяет ТОЧНО этот план
terraform apply tfplan
```{{execute}}

```bash
cat /tmp/tf-cmds/cr-it-staging.conf
```{{execute}}

```bash
cat << 'EOF'
ПОЧЕМУ это важно в production:

  terraform plan    <- запускает разработчик или CI
  [code review плана, одобрение]
  terraform apply tfplan  <- применяет ИМЕННО то что проверяли

  Если между plan и apply прошло время и что-то изменилось —
  apply tfplan всё равно применит ТОТ план, а не новый.

  apply без tfplan: может сделать больше чем показывал plan!
EOF
```{{execute}}

## -target: частичное применение

```bash
# Создаём только конкретный ресурс
terraform apply -auto-approve -target=random_id.id
```{{execute}}

```bash
cat << 'EOF'
ОСТОРОЖНО с -target:

  -target удобен для:
    - Отладки конкретного ресурса
    - Применения срочного фикса
    - Первоначального создания зависимости

  НЕ РЕКОМЕНДУЕТСЯ использовать постоянно:
    - Нарушает целостность state
    - Может создать inconsistency между ресурсами
    - terraform будет предупреждать об этом
EOF
```{{execute}}

## apply с -var и -var-file

```bash
# Создаём tfvars файл
cat > prod.tfvars << 'EOF'
env  = "production"
name = "webapp"
EOF
```{{execute}}

```bash
terraform apply -auto-approve -var-file=prod.tfvars
cat /tmp/tf-cmds/webapp-production.conf
```{{execute}}
