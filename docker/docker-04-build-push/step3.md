## Тегирование: docker tag

У одного образа может быть несколько тегов.
Это не копия — это просто дополнительное имя, указывающее на тот же ID образа.

Соглашение: `имя:latest` = последняя стабильная версия.

---

1. Создайте тег `latest` для v2:
`docker tag webserver:v2 webserver:latest`

2. Проверьте — v2 и latest имеют одинаковый IMAGE ID:
`docker images webserver`

3. Создайте тег с именем пользователя (как для Docker Hub):
`docker tag webserver:latest devopsstudent/webserver:v2`

4. Посмотрите все теги:
`docker images | grep webserver`
