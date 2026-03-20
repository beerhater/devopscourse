# Шаг 6: Первый ansible ping

`ansible all -m ping` — это "Hello World" в мире Ansible.
Проверяет: разбор инвентаря + SSH-соединение + Python на удалённом хосте.

```
Модуль ping НЕ отправляет ICMP-пакеты!
Он подключается по SSH, импортирует Python, возвращает {"ping": "pong"}
```

## Запускаем первый ping

```bash
cd ~/ansible-lab
ansible all -m ping
```{{execute}}

```bash
# Ping конкретной группы
ansible webservers -m ping
```{{execute}}

```bash
# Подробный вывод — видно точные параметры SSH-соединения
ansible all -m ping -v
```{{execute}}

```bash
# Очень подробный вывод — все параметры SSH
ansible all -m ping -vvv 2>&1 | head -40
```{{execute}}

## Разбираем вывод

```bash
cat << 'EOF'
node01 | SUCCESS => {
    "changed": false,   <- изменений на хосте не было
    "ping": "pong"      <- модуль выполнился успешно
}

node01 | FAILED!            <- соединение не удалось
  ...permission denied      <- проблема с SSH-аутентификацией
  ...no hosts matched       <- проблема с инвентарём
  ...python not found       <- Python не установлен на удалённом хосте
EOF
```{{execute}}

```bash
# Ping конкретного хоста по имени
ansible node01 -m ping
```{{execute}}

```bash
# Все хосты кроме node01 (полезно при большом количестве узлов)
ansible 'all,!node01' -m ping 2>/dev/null || echo "Других хостов нет (ожидаемо в 2-узловой лаборатории)"
```{{execute}}

## ping vs реальная проверка сети

```bash
# ansible ping = SSH + Python
ansible all -m ping

# Для проверки сети: модуль raw (Python не нужен)
ansible all -m raw -a "echo привет от raw"
```{{execute}}
