# Шаг 2: Собираем только builder stage

Иногда полезно отдельно проверить, что именно происходит на стадии сборки.

```bash
cd /opt/docker-multistage
docker build --target builder -t multistage-builder:v1 .
docker images multistage-builder:v1 --format '{{.Repository}}:{{.Tag}}' > /root/multistage_builder_image.txt
cat /root/multistage_builder_image.txt
```{{execute}}

Так можно локально отлаживать build-stage, не трогая финальный runtime-образ.
