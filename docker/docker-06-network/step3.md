## Создаём свою bridge-сеть

В пользовательской сети контейнеры находят друг друга по **имени** — автоматически.
Docker встроенный DNS резолвит имена контейнеров в IP-адреса.

---

1. Создайте пользовательскую сеть:
`docker network create mynet`

2. Посмотрите список сетей — mynet появилась:
`docker network ls`

3. Инспектируйте новую сеть:
`docker network inspect mynet`

4. Запустите два контейнера в вашей сети через флаг `--network`:
`docker run -d --name app1 --network mynet alpine sleep 300`
`docker run -d --name app2 --network mynet alpine sleep 300`
