# Урок завершён!

## Что изучили

- **State** -- память Terraform; связь ресурс в .tf <-> реальный объект
- **Структура tfstate** -- `version`, `serial`, `lineage`, `resources[].instances[].attributes`
- **`serial`** -- счётчик изменений; защита от конфликтов при concurrent write
- **Refresh цикл** -- desired vs known vs actual; `-refresh-only`
- **Drift detection** -- файл удалён/изменён вручную; `-detailed-exitcode` для CI
- **`state list/show/rm/mv`** -- управление state без пересоздания ресурсов
- **`state pull/push`** -- чтение и запись state (push — опасно)
- **Sensitive в state** -- пароли хранятся PLAINTEXT; шифровать на уровне backend
- **State locking** -- защита от двух одновременных apply; `force-unlock`
- **tfstate.backup** -- одна автоматическая копия; для истории нужен versioned backend
- **Проблемы локального state** -- нет командной работы, нет locking, секреты в git
- **Remote backend** -- S3+DynamoDB, YOS, Terraform Cloud: решает все проблемы

## Архитектура remote state

```
.tf файлы (в Git)          terraform.tfstate (НЕ в Git)
       │                           │
       ▼                           ▼
  terraform apply  ──────►  S3 Bucket (зашифрован)
                                   │
                             DynamoDB Lock Table
                             (предотвращает concurrent)
```

## Следующий урок

**Урок 6** — Remote State: настраиваем S3 backend через **MinIO в Docker**,
state locking, версионирование, `terraform_remote_state` data source.
