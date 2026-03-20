# Шаг 1: Установка Terraform

## Устанавливаем Terraform

```bash
# Добавляем репозиторий HashiCorp
apt-get update -qq && apt-get install -y -qq gnupg curl
```{{execute}}

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main"   | tee /etc/apt/sources.list.d/hashicorp.list
```{{execute}}

```bash
apt-get update -qq && apt-get install -y terraform
```{{execute}}

```bash
# Проверяем установку
terraform version
```{{execute}}

```bash
# Включаем автодополнение в bash
terraform -install-autocomplete 2>/dev/null || true
echo "Terraform установлен!"
```{{execute}}

## Что такое Terraform

```bash
cat << 'EOF'
Terraform — инструмент от HashiCorp для управления инфраструктурой.

Ключевые свойства:
  Декларативный   <- описываешь ЧТО хочешь, а не КАК это сделать
  Идемпотентный   <- запуск 10 раз = тот же результат что и 1 раз
  Провайдеры      <- работает с AWS, GCP, Azure, Yandex, Kubernetes, Docker...
  State-файл      <- помнит что создал и синхронизирует с реальностью
  Open Source     <- бесплатен для большинства сценариев
EOF
```{{execute}}

## Команды справки

```bash
# Список всех команд
terraform --help
```{{execute}}

```bash
# Справка по конкретной команде
terraform plan --help | head -20
```{{execute}}
