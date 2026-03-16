## Практика: запуск PostgreSQL с томом

Классический пример: база данных, которая не теряет данные при перезапуске.

---

1. Создайте том для базы данных:
`docker volume create pgdata`

2. Запустите PostgreSQL:
`docker run -d --name postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=mydb -v pgdata:/var/lib/postgresql/data postgres:15`

3. Подождите пока база запустится:
`sleep 5 && docker logs postgres | tail -5`

4. Создайте тестовую таблицу:
`docker exec -it postgres psql -U postgres -d mydb -c "CREATE TABLE users (id SERIAL, name TEXT);"`

5. Вставьте данные:
`docker exec -it postgres psql -U postgres -d mydb -c "INSERT INTO users (name) VALUES ('Alice'), ('Bob');"`

6. Проверьте данные:
`docker exec -it postgres psql -U postgres -d mydb -c "SELECT * FROM users;"`

7. Удалите контейнер, но НЕ том:
`docker rm -f postgres`

8. Создайте новый контейнер с тем же томом:
`docker run -d --name postgres2 -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=mydb -v pgdata:/var/lib/postgresql/data postgres:15`

9. Через 5 секунд проверьте данные:
`sleep 5 && docker exec -it postgres2 psql -U postgres -d mydb -c "SELECT * FROM users;"`

Alice и Bob на месте!
