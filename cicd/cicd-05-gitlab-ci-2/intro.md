# GitLab CI: Часть 2

В прошлом модуле мы освоили фундамент GitLab CI: stages, jobs, artifacts, cache, запуск через `gitlab-runner exec`. Теперь — профессиональный уровень.

## Что изучим

**GitLab Container Registry** — в GitLab встроен Docker registry. Не нужен отдельный Docker Hub: образы хранятся рядом с кодом, авторизация через встроенные переменные `$CI_REGISTRY_*`.

**`include:`** — большой `.gitlab-ci.yml` разбивается на файлы. В реальных проектах это сотни строк — важно держать конфиг читаемым.

**`extends:`** — переиспользование конфигурации jobs. Вместо копипасты — наследование от шаблона.

**Environments** — GitLab умеет трекить куда и что было задеплоено. В UI видно: "на staging сейчас v1.2.3, на production — v1.1.0".

**`rules:`** — умная логика запуска: разные jobs для MR, для веток, для тегов.

## Инструменты

> Проверяем Docker: `docker --version`{{execute}}

> Проверяем gitlab-runner: `gitlab-runner --version 2>/dev/null || (wget -qO /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 && chmod +x /usr/local/bin/gitlab-runner && gitlab-runner --version)`{{execute}}

> Создаём рабочую директорию: `mkdir -p /opt/gitlab-ci-2-demo && cd /opt/gitlab-ci-2-demo`{{execute}}
