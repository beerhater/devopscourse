# Шаг 7: Собираем финальный debugging-report

Соберите короткую сводку, чтобы было понятно:

- что за контейнер вы проверяли;
- какой у него образ;
- какой порт слушает;
- отвечает ли HTTP.

```bash
{
  echo "container=inspect-demo"
  echo "image=$(docker inspect inspect-demo --format '{{.Config.Image}}')"
  echo "port=$(cat /root/inspect_ports.txt)"
  echo "http_ok=$(grep -qi nginx /root/inspect_http.txt && echo yes || echo no)"
} > /root/inspect_final_report.txt

cat /root/inspect_final_report.txt
```{{execute}}
