# Шаг 3: SSH-ключи — как Ansible аутентифицируется

Ansible подключается по SSH. По умолчанию использует аутентификацию по ключам.

## Как работает аутентификация по ключу

```
1. Генерируем ПАРУ ключей: приватный + публичный
   id_rsa (приватный) -- НИКОМУ не передаём
   id_rsa.pub (публичный) -- копируем на серверы

2. Копируем публичный ключ на управляемый узел:
   ~/.ssh/authorized_keys на node01

3. Подключение: SSH доказывает, что вы владеете приватным ключом
   Пароль не нужен
```

## Проверяем текущий SSH-статус в лаборатории

```bash
ls -la ~/.ssh/
```{{execute}}

```bash
cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "Ключ ещё не создан"
```{{execute}}

## Генерируем SSH-ключ для Ansible

```bash
# Лучшая практика: отдельный ключ для автоматизации Ansible
ssh-keygen -t ed25519 -C "ansible-control" -f ~/.ssh/ansible_id -N ""
```{{execute}}

```bash
ls -la ~/.ssh/
echo ""
echo "Приватный ключ: ~/.ssh/ansible_id"
echo "Публичный ключ: ~/.ssh/ansible_id.pub"
cat ~/.ssh/ansible_id.pub
```{{execute}}

## Копируем публичный ключ на node01

```bash
ssh-copy-id -i ~/.ssh/ansible_id.pub root@node01
```{{execute}}

```bash
# Проверяем, что ключ добавлен
ssh root@node01 "tail -1 ~/.ssh/authorized_keys"
```{{execute}}

```bash
# Тестируем аутентификацию по ключу
ssh -i ~/.ssh/ansible_id root@node01 "echo 'Аутентификация по ключу работает! Пароль не нужен.'"
```{{execute}}

## Типы SSH-ключей

```bash
cat << 'EOF'
RSA (id_rsa)         -- классический, 2048+ бит, широкая поддержка
ECDSA (id_ecdsa)     -- меньше размер, быстрее, эллиптическая кривая
Ed25519 (id_ed25519) -- новейший, лучшая безопасность и скорость

Для Ansible: рекомендуем Ed25519 для новых установок
EOF
```{{execute}}
