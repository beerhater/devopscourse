## Список образов (images)

`docker images` показывает все локальные образы с метаданными.

---

1. Посмотрите все образы:
`docker images`

2. Отфильтруйте только nginx:
`docker images nginx`

3. Посмотрите ID образов в коротком формате:
`docker images -q`

4. Сохраните список в файл:
`docker images > /root/images_list.txt`

5. Проверьте что alpine занимает меньше всего места:
`docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"`
