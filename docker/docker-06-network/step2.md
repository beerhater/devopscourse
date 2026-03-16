## Bridge-сеть по умолчанию

Когда вы запускаете контейнер без указания сети — он попадает в `bridge`.
Контейнеры в bridge-сети по умолчанию **не находят друг друга по имени**,
только по IP-адресу. Это ограничение дефолтной bridge-сети.

---

1. Запустите два контейнера в сети по умолчанию:
`docker run -d --name c1 alpine sleep 300`
`docker run -d --name c2 alpine sleep 300`

2. Узнайте IP-адрес c1:
`docker inspect c1 --format='{{.NetworkSettings.IPAddress}}'`

3. Попробуйте достучаться из c2 до c1 по IP (подставьте реальный IP):
`docker exec c2 ping -c 2 $(docker inspect c1 --format='{{.NetworkSettings.IPAddress}}')`

4. Теперь попробуйте по имени — это НЕ работает в дефолтной сети:
`docker exec c2 ping -c 2 c1`

5. Остановите контейнеры: `docker rm -f c1 c2`
