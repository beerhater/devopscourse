# Step 10: Final task - provision a web server via ad-hoc

Use only ad-hoc commands to fully provision nginx on node01:
install, configure, create user, deploy content, start and verify.

## 1. Install nginx

```bash
cd ~/ansible-lab
ansible all -b -m apt -a "name=nginx,curl state=present update_cache=yes"
```{{execute}}

## 2. Create deploy user

```bash
ansible all -b -m user -a "name=deploy comment='Deploy user' state=present create_home=yes shell=/bin/bash"
```{{execute}}

```bash
ansible all -b -m authorized_key -a "user=deploy key='$(cat ~/.ssh/ansible_id.pub)' state=present"
```{{execute}}

## 3. Create web directory and set permissions

```bash
ansible all -b -m file -a "path=/var/www/myapp state=directory owner=deploy group=www-data mode=0755"
```{{execute}}

## 4. Deploy nginx config

```bash
cat > /tmp/myapp.conf << 'EOF'
server {
    listen 80;
    server_name _;
    root /var/www/myapp;
    index index.html;
    location /healthz { return 200 "OK
"; add_header Content-Type text/plain; }
}
EOF
```{{execute}}

```bash
ansible all -b -m copy -a "src=/tmp/myapp.conf dest=/etc/nginx/sites-available/myapp.conf owner=root group=root mode=0644"
```{{execute}}

```bash
# Enable site
ansible all -b -m file -a "src=/etc/nginx/sites-available/myapp.conf path=/etc/nginx/sites-enabled/myapp.conf state=link"
```{{execute}}

```bash
# Disable default site
ansible all -b -m file -a "path=/etc/nginx/sites-enabled/default state=absent"
```{{execute}}

## 5. Deploy index.html

```bash
ansible all -b -m copy -a "content='<h1>Deployed by Ansible ad-hoc!</h1>
' dest=/var/www/myapp/index.html owner=deploy group=www-data mode=0644"
```{{execute}}

## 6. Start and enable nginx

```bash
ansible all -b -m service -a "name=nginx state=restarted enabled=yes"
```{{execute}}

## 7. Verify

```bash
ansible all -m shell -a "curl -s http://localhost/"
ansible all -m shell -a "curl -s http://localhost/healthz"
ansible all -m shell -a "systemctl is-active nginx && systemctl is-enabled nginx"
```{{execute}}

## 8. Fetch nginx access log

```bash
ansible all -b -m shell -a "curl -s http://localhost/ > /dev/null && cat /var/log/nginx/access.log | tail -3"
```{{execute}}

## 9. Final state summary

```bash
ansible all -m shell -a "echo '=== nginx ===' && systemctl status nginx --no-pager | head -5"
ansible all -m shell -a "echo '=== users ===' && id deploy"
ansible all -m shell -a "echo '=== files ===' && ls -la /var/www/myapp/"
```{{execute}}
