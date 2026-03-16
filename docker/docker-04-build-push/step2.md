# Шаг 2: Кеш слоёв и оптимизация сборки

Docker кеширует каждый слой. Если инструкция и её контекст не изменились — слой берётся из кеша. Это ускоряет повторные сборки, но требует правильного порядка инструкций.

## Правило: нестабильные слои — вниз

Слои, которые меняются редко (установка зависимостей), должны быть **выше** слоёв, которые меняются часто (код приложения).

**Плохо — код копируется до установки зависимостей:**
```dockerfile
COPY . .
RUN pip install -r requirements.txt   # инвалидируется при любом изменении кода!
```

**Хорошо — зависимости устанавливаются отдельно:**
```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt   # кешируется, пока не изменится requirements.txt
COPY . .
```

## Задание: увидьте кеш в действии

```bash
cd /opt/buildapp
```{{execute}}

Первая сборка (нет кеша):
```bash
docker build -t cache-demo:1.0 .
```{{execute}}

Вторая сборка (всё из кеша — заметьте слово `CACHED`):
```bash
docker build -t cache-demo:1.0 .
```{{execute}}

Измените app.sh и пересоберите — только последние слои пересоберутся:
```bash
echo 'echo "Updated!"' >> app.sh
docker build -t cache-demo:2.0 .
```{{execute}}

Сборка без кеша (полная пересборка):
```bash
docker build --no-cache -t cache-demo:3.0 .
```{{execute}}

Посмотрите историю слоёв:
```bash
docker history cache-demo:1.0
```{{execute}}
