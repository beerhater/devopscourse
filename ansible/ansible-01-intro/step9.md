# Шаг 9: Сбор фактов — модуль setup

## ansible -m setup — собираем факты с хостов

```bash
cd ~/ansible-lab
# Модуль setup собирает ВСЕ факты об удалённом хосте
ansible all -m setup 2>/dev/null | head -50
```{{execute}}

```bash
# Фильтрация фактов по паттерну
ansible all -m setup -a "filter=ansible_os_family"
```{{execute}}

```bash
ansible all -m setup -a "filter=ansible_distribution*"
```{{execute}}

```bash
ansible all -m setup -a "filter=ansible_memtotal_mb"
```{{execute}}

```bash
ansible all -m setup -a "filter=ansible_processor_vcpus"
```{{execute}}

## Факты, которые вы будете использовать в плейбуках

```bash
cat << 'EOF'
ansible_hostname              <- короткое имя хоста
ansible_fqdn                  <- полное доменное имя
ansible_os_family             <- "Debian", "RedHat", "Suse"
ansible_distribution          <- "Ubuntu", "CentOS", "Debian"
ansible_distribution_version  <- "22.04", "9" и т.д.
ansible_default_ipv4.address  <- основной IP-адрес
ansible_memtotal_mb           <- суммарная RAM в МБ
ansible_processor_vcpus       <- количество ядер CPU
ansible_env.HOME              <- домашняя директория
ansible_date_time.date        <- текущая дата на удалённом хосте
EOF
```{{execute}}

```bash
# Сетевые факты
ansible all -m setup -a "filter=ansible_default_ipv4"
```{{execute}}

## Сравнение: -m command vs -m shell vs -m raw

```bash
cat << 'EOF'
-m raw      Python не нужен, команда выполняется напрямую по SSH
            Использовать для: начальной настройки, Windows, минимальных систем

-m command  модуль по умолчанию, команда БЕЗ оболочки shell
            нет конвейеров |, нет перенаправлений >, нет переменных $VAR
            Использовать для: простых команд

-m shell    команда выполняется ЧЕРЕЗ /bin/sh
            поддерживает: конвейеры | перенаправления > переменные $VAR
            Использовать для: сложных команд
EOF
```{{execute}}

```bash
ansible all -m command -a "hostname"
ansible all -m shell -a "hostname | tr a-z A-Z"
ansible all -m raw -a "uname -r"
```{{execute}}
