# Шаг 6: -m service — управление сервисами

Модуль `service` управляет системными сервисами (systemd и другими).

## Запуск и остановка сервисов

```bash
cd ~/ansible-lab

# Проверяем статус nginx
ansible all -b -m shell -a "systemctl is-active nginx || echo остановлен"
```{{execute}}

```bash
# Запустить nginx
ansible all -b -m service -a "name=nginx state=started"
```{{execute}}

```bash
# Проверяем, что запущен
ansible all -b -m shell -a "systemctl is-active nginx"
```{{execute}}

## Состояния сервиса (state)

```bash
cat << 'EOF'
state=started    запустить, если не запущен (ничего не делать, если уже запущен)
state=stopped    остановить, если запущен
state=restarted  всегда перезапустить (даже если уже запущен)
state=reloaded   перечитать конфигурацию (мягко, отправляет SIGHUP)
EOF
```{{execute}}

```bash
# Перезагрузка конфигурации nginx (мягкий перезапуск)
ansible all -b -m service -a "name=nginx state=reloaded"
```{{execute}}

## Включение/отключение автозапуска

```bash
# enabled=yes: запускать автоматически при старте системы
ansible all -b -m service -a "name=nginx enabled=yes"
```{{execute}}

```bash
# Проверяем
ansible all -b -m shell -a "systemctl is-enabled nginx"
```{{execute}}

```bash
# Запустить И включить автозапуск одной командой
ansible all -b -m service -a "name=nginx state=started enabled=yes"
```{{execute}}

## Остановить и отключить

```bash
ansible all -b -m service -a "name=nginx state=stopped enabled=no"
ansible all -b -m shell -a "systemctl is-active nginx || echo не активен"
```{{execute}}

## Модуль systemd: расширенный контроль

```bash
# Модуль systemd поддерживает daemon_reload и masked
ansible all -b -m systemd -a "name=nginx state=started enabled=yes daemon_reload=yes"
```{{execute}}
