# Шаг 7: Итоговое задание

Выполните полный цикл работы с контейнером строго по порядку.

**1. Запустите `nginx` в фоне с именем `final-nginx` и портом `9090:80`:**

```bash
docker run -d --name final-nginx -p 9090:80 nginx
```{{execute}}

**2. Убедитесь, что контейнер запущен:**

```bash
docker ps --filter "name=final-nginx"
```{{execute}}

**3. Проверьте работу nginx:**

```bash
curl http://localhost:9090
```{{execute}}

**4. Остановите контейнер:**

```bash
docker stop final-nginx
```{{execute}}

**5. Проверьте статус (должен быть Exited):**

```bash
docker ps -a --filter "name=final-nginx"
```{{execute}}

**6. Удалите контейнер:**

```bash
docker rm final-nginx
```{{execute}}

**7. Убедитесь, что контейнер удалён:**

```bash
docker ps -a
```{{execute}}
