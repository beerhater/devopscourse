# Шаг 2: Изучаем окружение лаборатории

## Два узла, одна сеть

```bash
echo "=== Управляющий узел ===" && hostname && ip addr show eth0 | grep 'inet '
```{{execute}}

```bash
echo "=== Управляемый узел ===" && ssh root@node01 "hostname && ip addr show eth0 | grep 'inet '"
```{{execute}}

```bash
# Оба узла видят друг друга по имени
ping -c 2 node01
```{{execute}}

```bash
# Python3 доступен на управляемом узле (требование Ansible)
ssh root@node01 "python3 --version && which python3"
```{{execute}}

```bash
# SSH-сервер запущен на node01 (Ansible подключается сюда)
ssh root@node01 "systemctl is-active ssh || systemctl is-active sshd"
```{{execute}}

## Что нужно на управляемом узле

```bash
cat << 'EOF'
Требования к управляемому узлу:
  [x] Python 3      -- для запуска модулей Ansible
  [x] SSH-сервер    -- чтобы Ansible мог подключиться
  [x] Рабочий юзер -- root или пользователь с sudo
  [ ] Ansible       -- НЕ НУЖЕН

Это всё. Никаких агентов. Никаких демонов. Никакой установки.
EOF
```{{execute}}

```bash
# SSH уже настроен между узлами в этой лаборатории
ssh root@node01 "echo 'SSH работает! node01 доступен.'"
```{{execute}}
