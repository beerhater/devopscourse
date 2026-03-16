## Сетевые драйверы Docker

---

1. Посмотрите список сетей по умолчанию:
`docker network ls`

Вы увидите три сети созданных Docker при установке:
- `bridge` — сеть по умолчанию
- `host` — сеть хоста
- `none` — без сети

2. Инспектируйте сеть bridge:
`docker network inspect bridge`

3. Сохраните список сетей в файл:
`docker network ls > /root/networks.txt`
