# Шаг 2: Скачивание образов — docker pull

`docker pull` скачивает образ из реестра в локальное хранилище, **не запуская** контейнер.

## Синтаксис

```
docker pull [OPTIONS] NAME[:TAG]
```

## Задание 1: Скачайте образ ubuntu

```bash
docker pull ubuntu
```{{execute}}

Вы увидите, как Docker скачивает слои образа по одному. Каждая строка `Pull complete` — это один слой.

## Задание 2: Скачайте образ alpine

`alpine` — минималистичный Linux (~5 МБ), часто используется как базовый образ:

```bash
docker pull alpine
```{{execute}}

## Задание 3: Скачайте образ nginx

```bash
docker pull nginx
```{{execute}}

## Проверьте, что образы скачались

```bash
docker images
```{{execute}}

Обратите внимание на столбец **SIZE** — alpine значительно меньше ubuntu!
