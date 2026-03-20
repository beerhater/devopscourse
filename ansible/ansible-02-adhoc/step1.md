# Шаг 1: Синтаксис ad-hoc и паттерны

## Полный синтаксис

```bash
ansible <паттерн> -m <модуль> -a "<аргументы>" [опции]

Опции:
  -i inventory     использовать конкретный файл инвентаря
  -u user          SSH-пользователь (переопределяет ansible.cfg)
  -b               become (sudo)
  --become-user    пользователь для sudo (по умолчанию root)
  -k               запросить SSH-пароль
  -v/-vv/-vvv      уровень детализации вывода
  -f N             запускать параллельно на N хостах (по умолчанию 5)
  -o               компактный однострочный вывод
  -C               режим проверки (dry-run, без изменений)
  --diff           показать разницу в файлах
```{{execute}}

## Паттерны — кого затронуть

```bash
cd ~/ansible-lab

# Все хосты
ansible all -m ping

# Конкретная группа
ansible webservers -m ping

# Конкретный хост по имени
ansible node01 -m ping
```{{execute}}

```bash
# Маска
ansible 'node*' -m ping
```{{execute}}

```bash
# Отрицание: все кроме node01
ansible 'all,!node01' -m ping 2>/dev/null || echo "Других хостов нет (ожидаемо)"
```{{execute}}

## Флаг -o: компактный однострочный вывод

```bash
cd ~/ansible-lab
ansible all -m ping -o
```{{execute}}

## Режим проверки: dry-run перед применением

```bash
# -C: симуляция без реальных изменений (поддерживается не всеми модулями)
ansible all -m command -a "uptime" -C
```{{execute}}
