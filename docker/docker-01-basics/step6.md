# Шаг 6: Флаги --name и --rm

## Флаг --name

Без имени Docker присваивает контейнеру случайное имя (например, `quirky_tesla`). Флаг `--name` позволяет задать понятное:

```bash
docker run -d --name web-server nginx
```{{execute}}

Теперь вместо ID можно использовать имя во всех командах:

```bash
docker stop web-server
docker rm web-server
```{{execute}}

## Флаг --rm

`--rm` автоматически удаляет контейнер сразу после его остановки. Идеально для разовых задач:

```bash
docker run --rm ubuntu echo "Привет, мир!"
```{{execute}}

Контейнер запустился, выполнил `echo` и сразу удалился. Проверьте — его нет в списке:

```bash
docker ps -a
```{{execute}}

## Задание

Запустите `alpine` с флагом `--rm`, выполнив команду `hostname`:

```bash
docker run --rm --name my-alpine alpine hostname
```{{execute}}
