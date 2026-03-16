# Поздравляем! Курс CI/CD завершён 🎉

## Что изучили в этом модуле

- **Recreate** — наглядно показывает почему downtime неприемлем в проде
- **Rolling Update** — замена инстансов по одному с health-check и авто-стопом при ошибке
- **Blue/Green** — два окружения, переключение за 0мс, откат одной командой
- **Canary** — nginx `weight=`, постепенный сдвиг трафика 10→50→100%
- **Feature Flags** — деплой кода без включения функций, откат без нового деплоя
- **Smoke Tests + Auto-Rollback** — автоматическая проверка и откат при падении

## Когда что применять

| Ситуация | Стратегия |
|----------|-----------|
| Dev/staging, некритично | Recreate |
| Обычный сервис, несколько инстансов | Rolling Update |
| Платежи, критичный путь | Blue/Green |
| Высокий трафик, хотим проверить на 1% | Canary |
| Большая рискованная фича | Feature Flags |

## Весь пройденный курс

| # | Модуль | Ключевые темы |
|---|--------|---------------|
| 01 | Введение в CI/CD | Pipeline, stages, jobs, artifacts |
| 02 | GitHub Actions ч.1 | Workflow, triggers, matrix |
| 03 | GitHub Actions ч.2 | Docker, registry, secrets |
| 04 | GitLab CI ч.1 | .gitlab-ci.yml, stages, gitlab-runner |
| 05 | GitLab CI ч.2 | include:, extends:, environments, rules: |
| 06 | Автотесты | pytest, go test, coverage, JUnit XML |
| 07 | Стратегии деплоя | Rolling, Blue/Green, Canary, Feature Flags |
