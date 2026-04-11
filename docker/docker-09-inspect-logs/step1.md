# Шаг 1: inspect, logs и exec на практике

Поднимите простой контейнер и соберите маленький debugging-report.

```bash
docker rm -f inspect-demo 2>/dev/null || true

docker run -d --name inspect-demo -p 8091:80 nginx:alpine >/dev/null
sleep 3

docker inspect inspect-demo | grep -E '"Image"|"IPAddress"|"HostPort"' > /root/inspect_demo_report.txt
docker logs inspect-demo > /root/inspect_demo_logs.txt 2>&1
docker exec inspect-demo sh -c 'nginx -v 2>&1 && test -f /etc/nginx/nginx.conf && echo config-ok' > /root/inspect_demo_exec.txt

cat /root/inspect_demo_report.txt
cat /root/inspect_demo_exec.txt
```{{execute}}

Что здесь важно:

- `docker inspect` даёт техническую правду о контейнере;
- `docker logs` нужен для первого чтения симптомов;
- `docker exec` помогает быстро посмотреть процесс и конфиг изнутри.
