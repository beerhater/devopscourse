## Сборка образа: docker build

Синтаксис: `docker build -t имя:тег путь_к_контексту`

Точка `.` в конце означает "текущая папка — контекст сборки".
Docker упаковывает все файлы из этой папки и передаёт демону.

---

1. Создайте папку проекта:
`mkdir -p /root/webserver && cd /root/webserver`

2. Создайте Dockerfile:
`nano Dockerfile`

3. Вставьте:
```
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

4. Создайте html-страницу:
`nano index.html`

```
<html>
<h1>Hello from my custom image!</h1>
<p>Built with Docker.</p>
</html>
```

5. Соберите образ:
`docker build -t webserver:v1 .`

Наблюдайте за выводом — вы видите каждый шаг сборки.
