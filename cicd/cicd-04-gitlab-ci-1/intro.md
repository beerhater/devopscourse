# GitLab CI: Часть 1

Мы изучили **GitHub Actions** — встроенную CI/CD систему GitHub. Теперь переходим к **GitLab CI** — встроенной CI/CD системе GitLab.

GitLab CI — один из самых популярных CI/CD инструментов в корпоративном секторе. Многие компании используют **self-hosted GitLab** — собственный сервер, полностью под контролем компании, без зависимости от внешних сервисов.

## GitHub Actions vs GitLab CI — ключевая разница

| | GitHub Actions | GitLab CI |
|--|--|--|
| Файл конфига | `.github/workflows/*.yml` | `.gitlab-ci.yml` (один файл!) |
| Единица работы | `jobs` | `jobs` внутри `stages` |
| Порядок выполнения | `needs:` | `stages:` (явный порядок) |
| Раннеры | GitHub-hosted | GitLab Runner (self-hosted или SaaS) |
| Артефакты | `actions/upload-artifact` | встроен в job через `artifacts:` |
| Кэш | `actions/cache` | встроен через `cache:` |
| Self-hosted | Возможно | **Основной сценарий** |

## Как мы будем практиковаться?

На Killercoda нет GitLab.com, но есть Docker. Мы поднимем **GitLab Runner в shell-режиме** — он умеет выполнять `.gitlab-ci.yml` локально, читая файл напрямую.

Инструмент называется **`gitlab-runner exec`** — он запускает отдельный job из `.gitlab-ci.yml` прямо на вашей машине без подключения к GitLab-серверу.

> Проверьте Docker: `docker --version`{{execute}}

> Установим GitLab Runner:
```bash
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash 2>/dev/null
sudo apt-get install -y gitlab-runner 2>/dev/null || true
gitlab-runner --version 2>/dev/null || (
  sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
  sudo chmod +x /usr/local/bin/gitlab-runner
  gitlab-runner --version
)
```{{execute}}
