# Step 4: -m copy - push files to remote hosts

The `copy` module copies files FROM control node TO managed nodes.

## Copy a file

```bash
cd ~/ansible-lab

# Create a local file to copy
echo "Hello from Ansible ad-hoc!" > /tmp/hello.txt
```{{execute}}

```bash
# Copy to remote host
ansible all -b -m copy -a "src=/tmp/hello.txt dest=/tmp/hello.txt"
```{{execute}}

```bash
# Verify
ansible all -m command -a "cat /tmp/hello.txt"
```{{execute}}

## Copy with permissions

```bash
ansible all -b -m copy -a "src=/tmp/hello.txt dest=/var/www/html/hello.txt owner=www-data group=www-data mode=0644"
```{{execute}}

```bash
ansible all -m shell -a "ls -la /var/www/html/hello.txt"
```{{execute}}

## content: write string directly (no local file needed)

```bash
# Write content directly to a file on remote
ansible all -b -m copy -a "content='server_name=node01
env=lab
' dest=/etc/myapp.conf"
```{{execute}}

```bash
ansible all -m command -a "cat /etc/myapp.conf"
```{{execute}}

## backup: keep original before overwriting

```bash
ansible all -b -m copy -a "content='updated content
' dest=/etc/myapp.conf backup=yes"
```{{execute}}

```bash
# Backup file created with timestamp
ansible all -m shell -a "ls /etc/myapp.conf*"
```{{execute}}

## Copy with validation (e.g. nginx config)

```bash
# Write nginx config
cat > /tmp/nginx-test.conf << 'EOF'
server {
    listen 8088;
    location / { return 200 "ad-hoc nginx
"; }
}
EOF
```{{execute}}

```bash
ansible all -b -m copy -a "src=/tmp/nginx-test.conf dest=/etc/nginx/sites-available/test.conf validate='nginx -t -c %s' backup=yes" 2>/dev/null || ansible all -b -m copy -a "src=/tmp/nginx-test.conf dest=/etc/nginx/conf.d/test.conf backup=yes"
```{{execute}}
