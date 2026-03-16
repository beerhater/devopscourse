## Named Volumes

Named Volume — том с именем. Docker хранит его в `/var/lib/docker/volumes/`.

---

1. Создайте том:
`docker volume create mydata`

2. Запустите контейнер с томом (`-v имя_тома:путь_в_контейнере`):
`docker run --name app -v mydata:/data alpine sh -c "echo 'persistent data' > /data/saved.txt"`

3. Контейнер завершился. Удалите его:
`docker rm app`

4. Запустите новый контейнер с тем же томом:
`docker run --name app2 -v mydata:/data alpine cat /data/saved.txt`

Данные сохранились! Том пережил удаление контейнера.

5. Удалите контейнер:
`docker rm app2`
