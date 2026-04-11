# Шаг 6: Пересобираем новую версию

Теперь обновим исходный артефакт и соберём новую версию образа.

```bash
cd /opt/docker-multistage
echo "platform release 2026-05" > app.txt
docker build -t multistage-demo:v2 .
docker rm -f multistage-demo-v2 2>/dev/null || true
docker run -d --name multistage-demo-v2 multistage-demo:v2 >/dev/null
sleep 2
docker exec multistage-demo-v2 cat /app/release.txt > /root/multistage_release_v2.txt
cat /root/multistage_release_v2.txt
```{{execute}}

Это показывает, как меняется только артефакт, а структура сборки остаётся той же.
