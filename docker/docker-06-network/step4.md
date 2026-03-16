## Связь контейнеров по имени

---

1. Из контейнера app2 пинганите app1 по имени:
`docker exec app2 ping -c 3 app1`

Это работает! Docker DNS резолвит `app1` в правильный IP.

2. Из app1 пинганите app2:
`docker exec app1 ping -c 3 app2`

3. Посмотрите какие контейнеры в сети mynet:
`docker network inspect mynet --format='{{range .Containers}}{{.Name}} {{.IPv4Address}}{{"\n"}}{{end}}'`

4. Подключите существующий контейнер к сети (один контейнер может быть в нескольких сетях):
`docker run -d --name solo alpine sleep 300`
`docker network connect mynet solo`
`docker exec solo ping -c 2 app1`

5. Остановите все: `docker rm -f app1 app2 solo`
