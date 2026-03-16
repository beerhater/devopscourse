# Поздравляем! 🎉

Вы завершили модуль **«GitHub Actions: Часть 1»**!

## Что вы освоили

- **Архитектуру GitHub Actions**: Event → Workflow → Job → Step → Runner
- **Структуру workflow-файла**: `name`, `on`, `jobs`, `runs-on`, `steps`
- **Триггеры**: `push`, `pull_request`, `schedule`, `workflow_dispatch`, `release`
- **Jobs и зависимости**: параллельность vs `needs`
- **Steps**: `run` vs `uses`, `if:`, `always()`
- **Переменные и контекст**: `env:`, `${{ github.* }}`, `$GITHUB_ENV`, `secrets`
- **`act`**: локальный запуск workflows без GitHub

## Минимальный рабочий CI

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: python3 -m pytest
```

99% реальных проектов начинаются именно с этого.

## Что дальше

В **GitHub Actions ч.2** добавим:
- Сборку Docker-образа в пайплайне
- Push в Docker Hub через секреты
- Matrix builds — тестирование на нескольких версиях Python

| Модуль | Статус |
|--------|--------|
| CI/CD 01: Введение, bash-пайплайн | Done |
| CI/CD 02: GitHub Actions ч.1 | Done |
| CI/CD 03: GitHub Actions ч.2 + Docker | Next |
| CI/CD 04: GitLab CI ч.1 | Soon |
| CI/CD 05: GitLab CI ч.2 | Soon |
| CI/CD 06: Автотесты | Soon |
| CI/CD 07: Стратегии деплоя | Soon |
