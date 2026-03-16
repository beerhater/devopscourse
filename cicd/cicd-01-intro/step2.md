# Шаг 2: Основные термины CI/CD

Прежде чем писать код — разберём **словарь**. В CI/CD много терминов, и их часто путают.

## CI vs CD — в чём разница?

```
┌─────────────────────────────────────────────────────────────┐
│                        CI/CD Pipeline                        │
│                                                              │
│  git push                                                    │
│     │                                                        │
│     ▼                                                        │
│  ┌──────────────────────────┐  ┌──────────────────────────┐  │
│  │   CI (Continuous         │  │   CD (Continuous         │  │
│  │   Integration)           │  │   Delivery/Deployment)   │  │
│  │                          │  │                          │  │
│  │  • Checkout кода         │  │  • Deploy на staging     │  │
│  │  • Установка зависимостей│  │  • Smoke tests           │  │
│  │  • Сборка (build)        │  │  • Deploy на production  │  │
│  │  • Запуск тестов         │  │  • Уведомления           │  │
│  │  • Линтинг кода          │  │                          │  │
│  └──────────────────────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

- **CI (Continuous Integration)** — автоматически интегрируем (собираем и тестируем) код при каждом коммите
- **CD (Continuous Delivery)** — автоматически готовим релиз, но деплой требует ручного подтверждения
- **CD (Continuous Deployment)** — полная автоматизация, деплой происходит без участия человека

## Ключевые термины

Создайте шпаргалку прямо в терминале:

```bash
cat > /opt/myapp/glossary.md << 'GLOSSARY'
# Глоссарий CI/CD

## Pipeline (Пайплайн)
Последовательность автоматических шагов от коммита до деплоя.
Аналогия: конвейер на заводе — каждая деталь проходит все станции.

## Stage (Стадия)
Группа связанных шагов пайплайна.
Например: stage "test" содержит unit-тесты, интеграционные тесты, линтинг.

## Job (Джоб/Задание)
Конкретная единица работы внутри stage.
Например: job "run-unit-tests" запускает pytest.

## Runner (Раннер)
Машина/контейнер на которой выполняются jobs.
Аналогия: рабочий на конвейере, который выполняет операцию.

## Artifact (Артефакт)
Файл, созданный в результате выполнения пайплайна.
Например: собранный бинарник, Docker-образ, отчёт о тестах.

## Trigger (Триггер)
Событие, которое запускает пайплайн.
Например: push в ветку main, создание pull request, расписание (cron).

## Environment (Окружение)
Среда для деплоя: dev, staging, production.

## Rollback (Откат)
Возврат к предыдущей рабочей версии при проблемах.
GLOSSARY
```{{execute}}

```bash
cat /opt/myapp/glossary.md
```{{execute}}

## Схема типичного пайплайна

```bash
cat > /opt/myapp/pipeline-schema.txt << 'SCHEMA'
Типичный CI/CD пайплайн:

git push
    │
    ▼
[STAGE: build]
    ├── job: install-dependencies    (pip install / npm install)
    └── job: compile                 (если нужна компиляция)
    │
    ▼ (только если build прошёл)
[STAGE: test]
    ├── job: unit-tests              (pytest, jest, go test)
    ├── job: integration-tests       (тесты с БД, внешними сервисами)
    └── job: lint                    (flake8, eslint, golangci-lint)
    │
    ▼ (только если test прошёл)
[STAGE: package]
    └── job: docker-build-push       (docker build + docker push)
    │
    ▼ (только если package прошёл)
[STAGE: deploy-staging]
    └── job: deploy                  (деплой на тестовый сервер)
    │
    ▼ (ручное подтверждение или автоматически)
[STAGE: deploy-production]
    └── job: deploy                  (деплой на боевой сервер)

Если ЛЮБОЙ job падает — пайплайн останавливается.
На production попадает только код прошедший ВСЕ проверки.
SCHEMA
```{{execute}}

```bash
cat /opt/myapp/pipeline-schema.txt
```{{execute}}

## Зелёный и красный пайплайн

```bash
cat > /opt/myapp/check-status.sh << 'SCRIPT'
#!/bin/bash

echo "==================================================="
echo "         Визуализация статусов пайплайна"
echo "==================================================="
echo ""
echo "✅ ЗЕЛЁНЫЙ пайплайн (всё прошло):"
echo "   [build: ✅] → [test: ✅] → [package: ✅] → [deploy: ✅]"
echo "   Результат: код задеплоен на production"
echo ""
echo "❌ КРАСНЫЙ пайплайн (тесты упали):"
echo "   [build: ✅] → [test: ❌]"
echo "   Результат: пайплайн остановлен, на production ничего не попало"
echo ""
echo "⚠️  КРАСНЫЙ пайплайн (ошибка сборки):"
echo "   [build: ❌]"
echo "   Результат: остановлен на первом шаге"
echo "==================================================="
SCRIPT
chmod +x /opt/myapp/check-status.sh
bash /opt/myapp/check-status.sh
```{{execute}}
