## Меняем группу через chgrp

В DevOps очень часто доступ к файлам дают не конкретному пользователю,
а группе. Например: `deploy`, `developers`, `docker`, `www-data`.

Команда `chgrp` меняет именно группу файла, не трогая владельца.

**Задание:**
1. Создайте группу, если её ещё нет: `getent group developers >/dev/null || groupadd developers`
2. Создайте файл для команды: `touch shared.txt`
3. Измените группу файла: `chgrp developers shared.txt`
4. Проверьте результат: `ls -la shared.txt`

Слева вы увидите того же владельца, но новая группа станет `developers`.
