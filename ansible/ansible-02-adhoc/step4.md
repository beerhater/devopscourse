# Шаг 4: -m copy — доставка файлов на хосты

Модуль `copy` копирует файлы С управляющего узла НА управляемые.

## Копируем файл

```bash
cd ~/ansible-lab

# Создаём локальный файл для копирования
echo "Привет от Ansible ad-hoc!" > /tmp/hello.txt
```{{execute}}

```bash
# Копируем на удалённый хост
ansible all -b -m copy -a "src=/tmp/hello.txt dest=/tmp/hello.txt"
```{{execute}}

```bash
# Проверяем
ansible all -m command -a "cat /tmp/hello.txt"
```{{execute}}

## Копирование с правами доступа

```bash
ansible all -b -m copy -a "src=/tmp/hello.txt dest=/var/www/html/hello.txt owner=www-data group=www-data mode=0644"
```{{execute}}

```bash
ansible all -m shell -a "ls -la /var/www/html/hello.txt"
```{{execute}}

## content: записать строку напрямую (без локального файла)

```bash
# Записываем содержимое прямо в файл на удалённом хосте
ansible all -b -m copy -a "content='server_name=node01
env=lab
' dest=/etc/myapp.conf"
```{{execute}}

```bash
ansible all -m command -a "cat /etc/myapp.conf"
```{{execute}}

## backup: сохранить оригинал перед перезаписью

```bash
ansible all -b -m copy -a "content='обновлённое содержимое
' dest=/etc/myapp.conf backup=yes"
```{{execute}}

```bash
# Файл резервной копии создаётся с временной меткой
ansible all -m shell -a "ls /etc/myapp.conf*"
```{{execute}}

## Копирование конфига nginx

```bash
cat > /tmp/nginx-test.conf << 'EOF'
server {
    listen 8088;
    location / { return 200 "nginx через ad-hoc
"; }
}
EOF
```{{execute}}

```bash
ansible all -b -m copy -a "src=/tmp/nginx-test.conf dest=/etc/nginx/conf.d/test.conf backup=yes"
```{{execute}}
