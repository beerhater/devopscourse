# GitHub Actions: Часть 2 — Docker в пайплайне

В прошлом модуле мы освоили структуру GitHub Actions: workflow, jobs, steps, триггеры. Теперь добавляем самое важное для DevOps-инженера — **автоматическую сборку и публикацию Docker-образа**.

## Что происходит в реальном проекте

```
Разработчик делает git push
        │
        ▼
GitHub Actions запускает workflow
        │
        ├── [job: test]     ← запускает pytest / тесты
        │         │
        │         ▼ (только если тесты прошли)
        ├── [job: build]    ← docker build
        │         │
        │         ▼ (только если сборка прошла)
        └── [job: push]     ← docker push → Docker Hub
                  │
                  ▼
        Образ доступен всему миру: docker pull yourname/app:latest
```

## Что мы будем использовать

**`docker/build-push-action`** — официальное Action от Docker для сборки и пуша образов. Оно умеет:
- Собирать multi-platform образы (amd64 + arm64)
- Кэшировать слои между запусками
- Пушить сразу в несколько registry

**`docker/login-action`** — Action для авторизации в Docker Hub (и других registry).

**`docker/metadata-action`** — автоматически генерирует теги образа из git-тегов, веток, SHA коммитов.

> Проверьте Docker: `docker --version`{{execute}}

> Убедитесь что `act` установлен: `act --version || (cd /tmp && wget -qO act.tar.gz https://github.com/nektos/act/releases/latest/download/act_Linux_x86_64.tar.gz && tar xzf act.tar.gz && mv act /usr/local/bin/ && chmod +x /usr/local/bin/act && act --version)`{{execute}}
