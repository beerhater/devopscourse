# Terraform. Урок 6 — Remote State

Локальный state не подходит для командной работы.
Поднимем **MinIO** в Docker (S3-совместимый), настроим remote backend
и разберём все механики: locking, версионирование, cross-state reference.

```
Что изучим:
  MinIO в Docker       <- S3-совместимое хранилище локально
  backend "s3"         <- конфигурация S3 backend
  init -migrate-state  <- перенос локального state в remote
  State locking        <- работа locking в remote backend
  Версионирование      <- история state через bucket versioning
  Несколько state      <- dev/staging/production через разные ключи
  terraform workspace  <- встроенные рабочие пространства
  terraform_remote_state <- чтение outputs другого state
  Backend config файл  <- partial configuration (без секретов в коде)
```

> Начнём: `terraform version && docker version`{{execute}}
