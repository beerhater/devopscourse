# Шаг 4: Drift Detection — расхождение реального мира и state

Drift — когда реальная инфраструктура отличается от того что знает Terraform.

## Симулируем разные типы drift

```bash
cd ~/tf-state
terraform apply -auto-approve
```{{execute}}

### Тип 1: Ресурс удалён вручную

```bash
cat << 'EOF'
Кто-то удалил файл не через Terraform:
  - Случайно (rm -rf /tmp/...)
  - Другим инструментом
  - Напрямую в AWS Console
EOF
```{{execute}}

```bash
# Удаляем файл вручную
rm -f /tmp/tf-state-demo/server.conf
ls /tmp/tf-state-demo/ 2>/dev/null || echo "(пусто)"
```{{execute}}

```bash
# Terraform обнаруживает drift
terraform plan
```{{execute}}

```bash
# Terraform предлагает пересоздать ресурс
terraform apply -auto-approve
cat /tmp/tf-state-demo/server.conf
```{{execute}}

### Тип 2: Ресурс изменён вручную

```bash
# Изменяем файл вручную
sed -i 's/port      = 8080/port      = 9999/' /tmp/tf-state-demo/server.conf
cat /tmp/tf-state-demo/server.conf
```{{execute}}

```bash
# Drift! Terraform видит расхождение
terraform plan
```{{execute}}

```bash
# Terraform хочет вернуть port = 8080
terraform apply -auto-approve
grep port /tmp/tf-state-demo/server.conf
```{{execute}}

### Тип 3: Ресурс создан вне Terraform (orphan)

```bash
cat << 'EOF'
Ресурс существует реально, но не в state.

Что делать:
  terraform import ADDR ID   <- импортировать в state

Пример:
  terraform import aws_instance.web i-abc123

После import:
  - Ресурс появляется в state
  - .tf файл нужно написать вручную под него
  - terraform plan должен показать "No changes"
EOF
```{{execute}}

## Мониторинг drift в CI/CD

```bash
cat << 'EOF'
Как автоматически детектировать drift:

  # В cron или scheduled CI job:
  terraform plan -detailed-exitcode -refresh-only

  Exit codes:
    0  <- нет изменений (no drift)
    1  <- ошибка
    2  <- есть изменения (drift detected!)

  if terraform plan -detailed-exitcode -refresh-only; then
    echo "Инфраструктура консистентна"
  else
    echo "DRIFT DETECTED! Alerting..."
    # отправить уведомление в Slack/Telegram
  fi
EOF
```{{execute}}

```bash
# Демо -detailed-exitcode
terraform plan -detailed-exitcode 2>/dev/null
echo "Exit code: $?"  # 0 = нет изменений
```{{execute}}
