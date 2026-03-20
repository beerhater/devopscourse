# Шаг 2: -m command и -m shell

Самые часто используемые модули для выполнения произвольных команд.

## -m command (модуль по умолчанию)

```bash
cd ~/ansible-lab

# command — МОДУЛЬ ПО УМОЛЧАНИЮ, -m command можно не писать
ansible all -m command -a "uptime"
```{{execute}}

```bash
# То же самое без -m command
ansible all -a "uptime"
```{{execute}}

```bash
ansible all -a "hostname"
ansible all -a "id"
ansible all -a "cat /etc/os-release"
```{{execute}}

```bash
# Свободная память
ansible all -a "free -h"
```{{execute}}

## Ограничения -m command

```bash
# command НЕ использует оболочку — нет конвейеров, нет перенаправлений, нет переменных
ansible all -m command -a "echo hello | tr a-z A-Z" 2>&1 || true
echo "Модуль command не умеет конвейеры — используйте shell"
```{{execute}}

## -m shell: полные возможности оболочки

```bash
# shell выполняется через /bin/sh — поддержка |, >, переменных
ansible all -m shell -a "echo hello | tr a-z A-Z"
```{{execute}}

```bash
ansible all -m shell -a "df -h | grep -E 'Size|/$'"
```{{execute}}

```bash
ansible all -m shell -a "ls /etc/*.conf | wc -l"
```{{execute}}

```bash
# chdir: перейти в директорию перед выполнением
ansible all -m shell -a "ls -la chdir=/etc/ssh"
```{{execute}}

```bash
# creates: пропустить, если файл уже существует (идемпотентность)
ansible all -m shell -a "echo 'создан' > /tmp/testfile creates=/tmp/testfile"
ansible all -m shell -a "echo 'создан' > /tmp/testfile creates=/tmp/testfile"
echo "Второй запуск пропущен (файл уже существует)"
```{{execute}}

## -m raw: когда Python недоступен

```bash
# raw обходит систему модулей — чистая SSH-команда
# Используется для: начальной настройки, минимальных систем
ansible all -m raw -a "uname -r"
```{{execute}}
