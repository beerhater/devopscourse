# Шаг 7: Итоговое задание

Применим всё изученное в одном сценарии.

**1. Скачайте образ `postgres` версии `15`:**

```bash
docker pull postgres:15
```{{execute}}

**2. Убедитесь, что образ появился локально:**

```bash
docker images postgres
```{{execute}}

**3. Посмотрите полную информацию об образе:**

```bash
docker inspect postgres:15
```{{execute}}

Обратите внимание на поля `Id`, `Created`, `Os`, `Architecture`, `RootFS.Layers` — последнее показывает количество слоёв образа.

**4. Запустите контейнер из этого образа:**

```bash
docker run -d --name my-postgres -e POSTGRES_PASSWORD=secret postgres:15
```{{execute}}

**5. Убедитесь, что контейнер работает:**

```bash
docker ps --filter "name=my-postgres"
```{{execute}}

**6. Остановите и удалите контейнер:**

```bash
docker stop my-postgres && docker rm my-postgres
```{{execute}}

**7. Удалите образ postgres:15:**

```bash
docker rmi postgres:15
```{{execute}}

**8. Проверьте использование диска:**

```bash
docker system df
```{{execute}}
