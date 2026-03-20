# Terraform. Урок 4 — Переменные и Outputs

Жёстко вписанные значения в `.tf`-файлах — плохая практика.
`variable` делает конфигурацию переиспользуемой, `output` — читаемой.

```
Что изучим:
  variable {}        <- объявление: type, default, description, validation
  Типы данных        <- string, number, bool, list, map, object, set, tuple
  Валидация          <- condition + error_message
  Сложные типы       <- list(object({...})), map(string)
  terraform.tfvars   <- файлы значений; *.auto.tfvars
  output {}          <- что отдаём наружу; description, sensitive
  sensitive outputs  <- скрываем секреты в выводе
  locals vs variable <- когда что использовать
  for выражения      <- итерация по коллекциям
```

> Начнём: `terraform version`{{execute}}
