# Terraform. Урок 5 — State-файл

`terraform.tfstate` — сердце Terraform. Без понимания state невозможно
работать в команде и нельзя доверять своей инфраструктуре.

```
Что изучим:
  Что такое state      <- зачем Terraform хранит "память"
  Структура tfstate    <- разбираем JSON изнутри
  Refresh цикл         <- как Terraform сравнивает state с реальностью
  Drift detection      <- расхождение state и реального мира
  terraform state *    <- list, show, rm, mv, pull, push
  Sensitive в state    <- пароли хранятся в открытом виде!
  State locking        <- защита от concurrent apply
  tfstate.backup       <- резервные копии
  Проблемы локального  <- почему нельзя хранить state в git
  Remote state         <- зачем S3/GCS и что это даёт
```

> Начнём: `terraform version`{{execute}}
