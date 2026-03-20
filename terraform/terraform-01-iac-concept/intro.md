# Terraform. Урок 1 — Концепция IaC

Раньше серверы создавали руками: заходишь в консоль AWS/GCP/Yandex Cloud,
нажимаешь кнопки, вводишь настройки. Это называется **ClickOps**.

```
ClickOps (руками):             IaC (Infrastructure as Code):

  Зайти в AWS Console             main.tf:
  → EC2 → Launch Instance   →       resource "aws_instance" "web" {
  → выбрать AMI                       ami           = "ami-0c55b..."
  → выбрать тип t2.micro               instance_type = "t2.micro"
  → настроить Security Group          }
  → нажать Launch
  → повторить для каждого сервера   terraform apply  # готово
```

**Terraform** — главный инструмент IaC в DevOps.
Описываем инфраструктуру в файлах `.tf` → Terraform сам создаёт, обновляет, удаляет ресурсы.

## Что изучим в этом уроке

- ClickOps vs IaC: в чём разница и зачем переходить
- Декларативный vs императивный подход
- Место Terraform в экосистеме IaC
- Установка Terraform
- HCL синтаксис: блоки, аргументы, выражения
- Провайдеры: что это и как работают
- Terraform Registry
- Структура проекта: какие файлы и зачем
- Базовый workflow: init → plan → apply → destroy
- Итоговое задание: пишем первый `.tf`-файл

> Начнём: `terraform version`{{execute}}
