## Инспекция и управление томами

---

1. Посмотрите список всех томов:
`docker volume ls`

2. Инспектируйте том mydata — узнайте где Docker его хранит на диске:
`docker volume inspect mydata`

3. Найдите путь к данным тома и посмотрите файлы:
`ls $(docker volume inspect mydata --format '{{.Mountpoint}}')`

4. Удалите неиспользуемые тома:
`docker volume prune -f`

5. Удалите конкретный том:
`docker volume rm mydata`

6. Проверьте что список пуст:
`docker volume ls`
