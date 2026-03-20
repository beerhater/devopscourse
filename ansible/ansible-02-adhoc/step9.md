# Шаг 9: Управление выводом и полезные паттерны

## -o: компактный однострочный вывод

```bash
cd ~/ansible-lab

ansible all -m setup -a "filter=ansible_hostname" -o
ansible all -m command -a "uptime" -o
```{{execute}}

## Параллельность с -f

```bash
# -f 10: запускать на 10 хостах параллельно (по умолчанию 5)
ansible all -m ping -f 10
```{{execute}}

## Просмотр JSON-ответа модуля

```bash
cat << 'EOF'
Ad-hoc не позволяет регистрировать переменные (это возможности плейбуков)
Но можно увидеть сырой JSON-ответ с флагом -v

ansible all -m command -a "uptime" -v
  показывает: rc (код возврата), stdout, stderr, start, end, delta
EOF
```{{execute}}

```bash
ansible all -m command -a "uptime" -v 2>&1 | grep -E 'rc|stdout|changed'
```{{execute}}

## Обработка ошибок

```bash
# По умолчанию: ненулевой код возврата = FAILED
ansible all -m shell -a "ls /несуществующий_путь" 2>&1 | head -5 || true
```{{execute}}

```bash
# Обходим ошибку: используем || echo
ansible all -m shell -a "ls /несуществующий_путь 2>/dev/null || echo не найдено"
```{{execute}}

## Become (sudo) паттерны

```bash
# -b: стать root
ansible all -b -m shell -a "whoami"
```{{execute}}

## Быстрая проверка состояния серверов

```bash
# Собираем несколько фактов за один проход
ansible all -m setup -a "filter=ansible_distribution"
```{{execute}}

```bash
ansible all -m setup -a "filter=ansible_memtotal_mb"
```{{execute}}

```bash
ansible all -m shell -a "df -h / | tail -1"
```{{execute}}
