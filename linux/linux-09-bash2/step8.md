## Практика — полноценный скрипт очистки

Соберём всё вместе: аргументы + функции + логирование.
Это будет скрипт для очистки старых лог-файлов — реальная задача DevOps-инженера.

---

**Шаг 1.** Создайте тестовые файлы которые будем чистить:
`touch /root/app.log.1 /root/app.log.2 /root/app.log.3`

**Шаг 2.** Создайте скрипт:
`nano cleanup.sh`

**Шаг 3.** Введите код:
```
#!/bin/bash
LOGFILE="/root/cleanup.log"
TARGET_DIR=${1:-"/root"}

function log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

function cleanup() {
    log "Начинаем очистку в: $1"
    COUNT=$(find "$1" -name "*.log.*" 2>/dev/null | wc -l)
    log "Найдено файлов для удаления: $COUNT"
    find "$1" -name "*.log.*" -delete 2>/dev/null
    log "Готово! Удалено файлов: $COUNT"
}

if [ ! -d "$TARGET_DIR" ]; then
    log "Ошибка: папка $TARGET_DIR не существует"
    exit 1
fi

cleanup "$TARGET_DIR"
```
Сохраните: `Ctrl+O` → Enter → `Ctrl+X`

**Шаг 4.** Запустите:
`chmod +x cleanup.sh && ./cleanup.sh /root`

**Шаг 5.** Посмотрите лог:
`cat /root/cleanup.log`
