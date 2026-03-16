## Возврат значения из функции

В Bash `return` работает не так как в Python или JS.
`return` может вернуть только число (код 0 или 1 — успех/ошибка).

Чтобы вернуть **строку или текст** из функции — используйте трюк:
напишите `echo` внутри функции, а снаружи захватите через `$()`.

```
function get_something() {
    echo "это результат"   # "возвращаем" через echo
}

RESULT=$(get_something)   # захватываем через $()
echo "Получили: $RESULT"
```

---

**Шаг 1.** Создайте скрипт:
`nano func_return.sh`

**Шаг 2.** Введите код:
```
#!/bin/bash

function get_date() {
    echo "$(date '+%Y-%m-%d')"
}

function get_free_memory() {
    FREE=$(free -m | awk 'NR==2{print $4}')
    echo "${FREE}MB"
}

TODAY=$(get_date)
MEMORY=$(get_free_memory)

echo "Дата бэкапа: $TODAY"
echo "Свободная память: $MEMORY"
echo "Файл бэкапа: backup_${TODAY}.tar.gz"
```
Сохраните: `Ctrl+O` → Enter → `Ctrl+X`

**Шаг 3.** Запустите:
`chmod +x func_return.sh && ./func_return.sh`
