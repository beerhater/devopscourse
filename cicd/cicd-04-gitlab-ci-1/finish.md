# Поздравляем! 🎉

Вы завершили модуль **«GitLab CI: Часть 1»**!

## Что вы освоили

- **Архитектуру GitLab CI**: Pipeline → Stage → Job → Runner
- **Структуру `.gitlab-ci.yml`**: `stages`, `variables`, `default`, `image`
- **Анатомию job**: `script`, `before_script`, `after_script`, `when`, `rules`, `only/except`
- **Stages vs needs**: порядок через stages против графа зависимостей
- **Artifacts**: передача файлов между jobs в одном пайплайне
- **Cache**: ускорение между запусками (по ветке, по хэшу файла)
- **`gitlab-runner exec shell`**: локальный запуск jobs без GitLab-сервера
- **Специальные stages**: `.pre` и `.post`

## Главная разница GitHub Actions vs GitLab CI

```
GitHub Actions:          GitLab CI:
  jobs:                    stages: [test, build]
    test: ...                test-job:
    build:                     stage: test
      needs: [test]            script: ...
```

GitLab CI явно объявляет порядок через `stages` — это делает пайплайн более читаемым в больших командах.

## Что дальше

В **GitLab CI ч.2** добавим:
- Docker build и push в GitLab Container Registry
- Include — разбивка большого `.gitlab-ci.yml` на файлы
- Environments и Deployments в GitLab UI
- GitLab-specific: MR pipelines, protected branches

| Модуль | Статус |
|--------|--------|
| CI/CD 01: Введение | Done |
| CI/CD 02: GitHub Actions ч.1 | Done |
| CI/CD 03: GitHub Actions ч.2 + Docker | Done |
| CI/CD 04: GitLab CI ч.1 | Done |
| CI/CD 05: GitLab CI ч.2 | Next |
| CI/CD 06: Автотесты | Soon |
| CI/CD 07: Стратегии деплоя | Soon |
