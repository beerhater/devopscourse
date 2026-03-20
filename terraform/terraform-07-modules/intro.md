# Terraform. Урок 7 — Модули

Копипаст конфигов — худшее что можно делать в Terraform.
`module` — механизм переиспользования: пишешь один раз, используешь везде.

```
Что изучим:
  Зачем модули          <- DRY принцип в Infrastructure as Code
  Структура модуля      <- variables.tf, main.tf, outputs.tf
  Локальный модуль      <- module { source = "./modules/..." }
  inputs и outputs      <- как данные текут между модулями
  Вложенные модули      <- модуль вызывает другой модуль
  for_each с модулями   <- создаём N экземпляров модуля
  Публичный реестр      <- registry.terraform.io
  Версионирование       <- version = "~> x.y"
  Git source            <- source = "git::https://..."
  Итоговый проект       <- полная библиотека модулей
```

> Начнём: `terraform version`{{execute}}
