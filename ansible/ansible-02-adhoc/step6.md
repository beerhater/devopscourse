# Step 6: -m service - manage system services

The `service` module manages systemd (and other init) services.

## Start and stop services

```bash
cd ~/ansible-lab

# Check nginx status
ansible all -b -m shell -a "systemctl is-active nginx || echo stopped"
```{{execute}}

```bash
# Start nginx
ansible all -b -m service -a "name=nginx state=started"
```{{execute}}

```bash
# Check it is running
ansible all -b -m shell -a "systemctl is-active nginx"
```{{execute}}

## Service states

```bash
cat << 'EOF'
state=started    start if not running (do nothing if already started)
state=stopped    stop if running
state=restarted  always restart (even if already running)
state=reloaded   reload config (graceful, sends SIGHUP)
EOF
```{{execute}}

```bash
# Reload nginx (graceful config reload)
ansible all -b -m service -a "name=nginx state=reloaded"
```{{execute}}

## Enable/disable on boot

```bash
# Enable: start automatically on system boot
ansible all -b -m service -a "name=nginx enabled=yes"
```{{execute}}

```bash
# Verify enabled
ansible all -b -m shell -a "systemctl is-enabled nginx"
```{{execute}}

```bash
# Start AND enable in one command
ansible all -b -m service -a "name=nginx state=started enabled=yes"
```{{execute}}

## Stop and disable

```bash
ansible all -b -m service -a "name=nginx state=stopped enabled=no"
ansible all -b -m shell -a "systemctl is-active nginx || echo not-active"
```{{execute}}

## systemd module: more control

```bash
# systemd module supports daemon-reload and masked
ansible all -b -m systemd -a "name=nginx state=started enabled=yes daemon_reload=yes"
```{{execute}}
