## Docker Hub и теги образов

Docker Hub — это реестр с сотнями тысяч образов.
Образы бывают **официальные** (поддерживает Docker Inc) и **пользовательские**.

---

1. Найдите образы nginx:
`docker search nginx`

Обратите внимание на колонки `STARS` и `OFFICIAL`.

2. Найдите только официальные образы:
`docker search --filter is-official=true nginx`

3. Сохраните результат поиска:
`docker search nginx > /root/nginx_search.txt`

4. Посмотрите сохранённый файл:
`cat /root/nginx_search.txt`
