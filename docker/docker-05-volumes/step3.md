## Bind Mount

Bind Mount монтирует **конкретную папку хоста** в контейнер.
Идеально для разработки: меняете файл на хосте — изменение сразу в контейнере.

Синтаксис: `-v /абсолютный/путь/на/хосте:/путь/в/контейнере`

---

1. Создайте папку на хосте:
`mkdir -p /root/html`

2. Создайте в ней файл:
`echo "<h1>Live reload!</h1>" > /root/html/index.html`

3. Запустите nginx с bind mount:
`docker run -d --name web -v /root/html:/usr/share/nginx/html -p 8080:80 nginx`

4. Проверьте:
`curl http://localhost:8080`

5. Измените файл на хосте и снова проверьте:
`echo "<h1>Updated without restart!</h1>" > /root/html/index.html`
`curl http://localhost:8080`

Nginx сразу отдаёт новый файл — без перезапуска контейнера!

6. Остановите контейнер: `docker stop web && docker rm web`
