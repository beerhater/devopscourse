## Меняем владельца через chown

`chown` меняет владельца файла.
Синтаксис: `chown пользователь:группа файл`

**Задание:**
1. Создайте пользователя: `id -u devops >/dev/null 2>&1 || useradd devops`
2. Создайте файл: `touch devopsfile.txt`
3. Передайте владение: `chown devops:devops devopsfile.txt`
4. Проверьте: `ls -la devopsfile.txt`

Вы увидите что владелец изменился с `root` на `devops`.
