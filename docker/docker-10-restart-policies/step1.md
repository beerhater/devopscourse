# Шаг 1: Политики рестарта на практике

Создайте контейнер, который завершится с ошибкой, и посмотрите, какая policy у него задана.

```bash
docker rm -f restart-demo 2>/dev/null || true

docker run -d --name restart-demo --restart on-failure:3 alpine sh -c 'echo crash-demo; exit 1' >/dev/null
sleep 4

docker inspect restart-demo --format '{{.HostConfig.RestartPolicy.Name}} {{.HostConfig.RestartPolicy.MaximumRetryCount}}' > /root/restart_policy.txt
docker ps -a --filter name=restart-demo --format '{{.Names}} {{.Status}}' > /root/restart_status.txt
docker logs restart-demo > /root/restart_logs.txt 2>&1

cat /root/restart_policy.txt
cat /root/restart_status.txt
```{{execute}}

Где это встречается:

- воркер должен подниматься после сбоя;
- одноразовый job-контейнер не должен рестартовать бесконечно;
- policy помогает понять, кто отвечает за авторестарт: Docker или внешняя оркестрация.
