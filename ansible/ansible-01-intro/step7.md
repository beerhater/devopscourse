# Step 7: Inventory groups and host variables

## Multiple groups and group nesting

```bash
cat > ~/ansible-lab/hosts << 'EOF'
# Single managed node in multiple groups
[webservers]
node01

[appservers]
node01

[databases]
# empty in this lab

# Parent group: contains child groups
[production:children]
webservers
appservers

# Variables for production group (inherited by children)
[production:vars]
env=production
deploy_user=deploy

# Variables for webservers group
[webservers:vars]
http_port=80
https_port=443

# All hosts get these
[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=root
EOF
cat ~/ansible-lab/hosts
```{{execute}}

```bash
cd ~/ansible-lab
ansible-inventory --graph
```{{execute}}

```bash
# See all variables for node01 (from all groups combined)
ansible-inventory --host node01
```{{execute}}

## Host-level variables

```bash
cat > ~/ansible-lab/hosts << 'EOF'
[webservers]
node01 http_port=80 server_name=web01.lab

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
```{{execute}}

```bash
cd ~/ansible-lab
ansible-inventory --host node01
```{{execute}}

## host_vars and group_vars directories (best practice)

```bash
# Variables in files instead of inline - cleaner for many vars
mkdir -p ~/ansible-lab/host_vars
mkdir -p ~/ansible-lab/group_vars

cat > ~/ansible-lab/host_vars/node01.yml << 'EOF'
http_port: 80
server_name: "web01.lab"
max_connections: 1024
EOF

cat > ~/ansible-lab/group_vars/webservers.yml << 'EOF'
nginx_version: "1.25"
deploy_path: /var/www/html
EOF

cat > ~/ansible-lab/group_vars/all.yml << 'EOF'
ansible_python_interpreter: /usr/bin/python3
timezone: UTC
ntp_server: pool.ntp.org
EOF
```{{execute}}

```bash
cd ~/ansible-lab
# Now ansible-inventory picks up variables from files automatically
ansible-inventory --host node01
```{{execute}}

```bash
# Clean up inline vars from hosts file
cat > ~/ansible-lab/hosts << 'EOF'
[webservers]
node01

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
```{{execute}}
