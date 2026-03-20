# Урок завершён!

## Что изучили

- **MinIO** -- S3-совместимое хранилище в Docker; `mc` client; версионирование bucket
- **backend "s3"** -- все поля; `endpoints` для MinIO/YOS; `use_path_style`
- **`init -migrate-state`** -- перенос локального state в remote; `-reconfigure`
- **State locking** -- DynamoDB для AWS; `-lock=false`; `-lock-timeout`; `force-unlock`
- **Версионирование** -- история state; восстановление по версии; lifecycle policy
- **Несколько state** -- разные `key` для dev/staging/prod; изоляция окружений
- **terraform workspace** -- встроенная изоляция; `terraform.workspace`; когда НЕ использовать
- **`terraform_remote_state`** -- data source для чтения outputs другого state
- **Partial backend config** -- `-backend-config=backend.hcl`; секреты не в git
- **Переменные окружения** -- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` для CI/CD

## Remote backend в production

```
┌─────────────────────────────────────────────────┐
│  providers.tf (в git)                           │
│  backend "s3" {                                 │
│    bucket  = "my-terraform-state"               │
│    key     = "prod/terraform.tfstate"           │
│    encrypt = true                               │
│    # секреты — через AWS IAM Role (лучший вариант) │
│  }                                              │
└─────────────────────┬───────────────────────────┘
                      │
         ┌────────────▼──────────────┐
         │  S3 Bucket (SSE-KMS)     │
         │  + Versioning            │
         │  + Lifecycle Policy      │
         └────────────┬─────────────┘
                      │ locking
         ┌────────────▼─────────────┐
         │  DynamoDB Table          │
         │  (или YOS встроенный)    │
         └──────────────────────────┘
```

## Следующий урок

**Урок 7** — Модули: создаём переиспользуемые модули,
`module` блок, входные/выходные переменные, источники модулей (local, registry, git).
