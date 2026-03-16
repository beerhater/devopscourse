## Проблема потери данных

Сначала убедимся, что проблема реальна.

---

1. Запустите контейнер и создайте в нём файл:
`docker run --name test -it alpine sh -c "echo 'important data' > /data/file.txt && cat /data/file.txt"`

2. Удалите контейнер:
`docker rm test`

3. Запустите новый контейнер из того же образа:
`docker run --name test2 alpine cat /data/file.txt`

Вы увидите ошибку — файла нет. Данные потеряны.

4. Удалите второй контейнер:
`docker rm test2`

Это именно та проблема которую решают тома.
