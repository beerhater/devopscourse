# Поздравляем! 🎉

Вы завершили модуль **«GitLab CI: Часть 2»**!

## Что вы освоили

- **GitLab Container Registry**: встроенные переменные `$CI_REGISTRY_*`, авторизация без секретов, локальный registry через Docker
- **Docker build в пайплайне**: DinD (Docker-in-Docker), полный цикл build → push → smoke-test → deploy
- **`include:`**: разбивка конфига на файлы (local, project, remote, template)
- **`extends:`**: наследование job-конфигурации от шаблонов, множественное наследование
- **YAML anchors**: `&anchor` / `*anchor` / `<<: *merge`
- **Environments**: трекинг деплоев в UI, статические и динамические окружения, Review Apps, `on_stop:`
- **`rules:`**: `if:`, `changes:`, `exists:`, переменные внутри rules, `allow_failure:`, scheduled pipelines

## Полный GitLab CI/CD — итоговая структура

```yaml
stages: [lint, test, build, deploy]

include:
  - local: ci/lint.yml
  - local: ci/test.yml
  - local: ci/docker.yml
  - local: ci/deploy.yml
```

Каждый файл — один аспект пайплайна. Чисто, читаемо, поддерживаемо.

## Что дальше

| Модуль | Статус |
|--------|--------|
| CI/CD 01: Введение | Done |
| CI/CD 02: GitHub Actions ч.1 | Done |
| CI/CD 03: GitHub Actions ч.2 + Docker | Done |
| CI/CD 04: GitLab CI ч.1 | Done |
| CI/CD 05: GitLab CI ч.2 | Done |
| CI/CD 06: Автотесты в CI | Next |
| CI/CD 07: Стратегии деплоя | Soon |
