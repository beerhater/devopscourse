## Docker Push и публичные реестры

`docker push` отправляет образ в реестр чтобы другие могли его скачать.

Кроме Docker Hub существуют:
- **GitHub Container Registry** (ghcr.io)
- **AWS ECR** (Elastic Container Registry)
- **Google Artifact Registry**
- **GitLab Registry**
- **Harbor** — self-hosted опция

---

Полная цепочка публикации (без реального выполнения):

1. Войдите в Docker Hub:
`docker login`

2. Переименуйте образ с вашим username:
`docker tag webserver:latest ВАШ_USERNAME/webserver:latest`

3. Опубликуйте:
`docker push ВАШ_USERNAME/webserver:latest`

4. Чтобы скачать на любом другом сервере:
`docker pull ВАШ_USERNAME/webserver:latest`

---

Сохраните понимание этого флоу в файл:
`echo "build -> tag -> push -> pull" > /root/docker_flow.txt`
