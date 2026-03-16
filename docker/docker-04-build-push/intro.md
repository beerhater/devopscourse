## Урок 4: Сборка и тегирование

Dockerfile это рецепт. `docker build` — это повар, который готовит по рецепту.
Результат — готовый образ, который можно запускать где угодно.

---

### Полный цикл работы с образом:
1. Написали `Dockerfile`
2. Собрали образ: `docker build -t myapp:v1 .`
3. Протестировали локально: `docker run myapp:v1`
4. Создали тег для реестра: `docker tag myapp:v1 username/myapp:v1`
5. Опубликовали: `docker push username/myapp:v1`
6. На сервере: `docker pull username/myapp:v1`

Именно так выглядит деплой через Docker.
