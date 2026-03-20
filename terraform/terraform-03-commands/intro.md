# Terraform. Урок 3 — Основные команды

В прошлых уроках мы использовали команды поверхностно.
Теперь разберём каждую команду во всех деталях: флаги, сценарии, ловушки.

```
Команды этого урока:
  terraform init      <- инициализация: флаги, -upgrade, -reconfigure
  terraform fmt       <- форматирование кода
  terraform validate  <- проверка синтаксиса и логики
  terraform plan      <- детали вывода, -out, -target, -var, -destroy
  terraform apply     <- флаги, -auto-approve, -target, tfplan файл
  terraform destroy   <- полное удаление и -target
  terraform show      <- просмотр state и планов
  terraform state     <- управление state: list, show, rm, mv
  terraform output    <- чтение outputs
  terraform console   <- интерактивная консоль HCL
```

> Начнём: `terraform version`{{execute}}
