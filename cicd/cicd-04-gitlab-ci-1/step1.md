# Шаг 1: GitLab CI vs GitHub Actions — концептуальное сравнение

## Разные подходы к одной задаче

Оба инструмента решают одну задачу — автоматизация CI/CD — но делают это по-разному. Понимание разницы поможет вам работать в любой компании.

```bash
mkdir -p /opt/gitlab-ci-demo
cd /opt/gitlab-ci-demo
```{{execute}}

```bash
cat > /opt/gitlab-ci-demo/comparison.txt << 'EOF'
════════════════════════════════════════════════════════
  GITHUB ACTIONS vs GITLAB CI: АРХИТЕКТУРНАЯ РАЗНИЦА
════════════════════════════════════════════════════════

GITHUB ACTIONS — jobs-first подход
────────────────────────────────────
Порядок задаётся через needs:
  jobs:
    lint:
      ...
    test:
      needs: lint    ← явная зависимость
    build:
      needs: test

Плюс: гибкость — любой граф зависимостей
Минус: нужно явно указывать needs везде

GITLAB CI — stages-first подход
─────────────────────────────────
Порядок задаётся через stages:
  stages:
    - lint      ← сначала
    - test      ← потом
    - build     ← потом

  lint-job:
    stage: lint   ← job автоматически идёт в нужный stage

Плюс: сразу виден порядок, нет лапши needs
Минус: внутри одного stage все jobs параллельны,
       нельзя задать порядок без нового stage

════════════════════════════════════════════════════════

КЛЮЧЕВОЕ ОТЛИЧИЕ: один файл vs много файлов
  GitHub Actions: .github/workflows/ci.yml
                  .github/workflows/deploy.yml
                  .github/workflows/release.yml
  GitLab CI:      .gitlab-ci.yml  ← ОДИН файл на всё
                  (но можно делать include: других файлов)

════════════════════════════════════════════════════════
EOF
cat /opt/gitlab-ci-demo/comparison.txt
```{{execute}}

## Терминология GitLab CI

```bash
cat > /opt/gitlab-ci-demo/terminology.txt << 'EOF'
ТЕРМИНЫ GITLAB CI
=================

Pipeline  — весь процесс CI/CD (аналог Workflow в GitHub Actions)
            Запускается при push, MR, schedule, вручную

Stage     — фаза пайплайна: test, build, deploy
            Stages выполняются ПОСЛЕДОВАТЕЛЬНО
            Внутри stage все jobs — ПАРАЛЛЕЛЬНО

Job       — конкретная задача (аналог job в GitHub Actions)
            Каждый job имеет свой stage
            Содержит script: — список команд

Runner    — машина на которой выполняется job
            Типы: shell, docker, kubernetes, virtualbox
            Можно self-hosted (своя машина) или GitLab SaaS

Artifact  — файлы которые job сохраняет после выполнения
            Доступны для скачивания и для следующих jobs

Cache     — файлы между запусками одного job
            node_modules/, .venv/, ~/.m2/ и т.д.

MR        — Merge Request (аналог Pull Request в GitHub)

.gitlab-ci.yml — файл конфигурации пайплайна
                 Лежит в корне репозитория

EOF
cat /opt/gitlab-ci-demo/terminology.txt
```{{execute}}

## Структура пайплайна визуально

```bash
cat << 'EOF'
СТРУКТУРА GITLAB CI PIPELINE
==============================

stages: [test, build, deploy]

─── STAGE: test ──────────────────────── запускается 1-м
    [job: unit-tests]  [job: lint]        оба параллельно
         ↓ (оба должны пройти)
─── STAGE: build ─────────────────────── запускается 2-м
    [job: docker-build]                   один job
         ↓
─── STAGE: deploy ────────────────────── запускается 3-м
    [job: deploy-staging]                 один job
         ↓
         ✅ Pipeline пройден!

ВАЖНО: если хотя бы один job в stage упал —
       следующий stage НЕ ЗАПУСКАЕТСЯ
EOF
```{{execute}}
