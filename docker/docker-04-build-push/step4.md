## Запуск собственного образа

Теперь запустим то, что собрали, и убедимся что всё работает.

---

1. Запустите контейнер из своего образа:
`docker run -d --name mywebserver -p 8080:80 webserver:latest`

2. Убедитесь что контейнер запущен:
`docker ps`

3. Проверьте что отдаёт наш nginx:
`curl http://localhost:8080`

Вы должны увидеть ваш HTML!

4. Остановите и удалите контейнер:
`docker stop mywebserver && docker rm mywebserver`
