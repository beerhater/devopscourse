# Шаг 1: Пишем multi-stage Dockerfile

Соберите маленькое приложение в две стадии: build и runtime.

```bash
mkdir -p /opt/docker-multistage
cd /opt/docker-multistage

cat > app.txt <<'EOF'
platform release 2026-04
EOF

cat > Dockerfile <<'EOF'
FROM alpine:3.20 AS builder
WORKDIR /src
COPY app.txt .
RUN cp app.txt /release.txt

FROM alpine:3.20
WORKDIR /app
COPY --from=builder /release.txt /app/release.txt
CMD ["sh", "-c", "cat /app/release.txt && sleep 3600"]
EOF

docker build -t multistage-demo:v1 .
docker run -d --name multistage-demo multistage-demo:v1 >/dev/null
sleep 2

docker inspect multistage-demo:v1 --format '{{.Config.WorkingDir}}' > /root/multistage_workdir.txt
docker exec multistage-demo cat /app/release.txt > /root/multistage_release.txt
grep -n 'COPY --from=builder' Dockerfile > /root/multistage_copy_from.txt

cat /root/multistage_release.txt
```{{execute}}

Ключевая идея:

- первая стадия что-то подготавливает;
- во вторую переносится только нужный артефакт.
