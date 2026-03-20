# Step 4: First inventory file - INI format

The inventory tells Ansible WHERE to connect.
Default location: `/etc/ansible/hosts` or custom file with `-i` flag.

## Create project directory

```bash
mkdir -p ~/ansible-lab && cd ~/ansible-lab
```{{execute}}

## Basic INI inventory

```bash
cat > ~/ansible-lab/hosts << 'EOF'
# This is a comment

# Ungrouped hosts (implicit 'all' group)
node01

# Named group: [groupname]
[webservers]
node01

[databases]
# node02  (we only have one managed node in this lab)
EOF
cat ~/ansible-lab/hosts
```{{execute}}

## INI format with connection variables

```bash
cat > ~/ansible-lab/hosts << 'EOF'
# Host with connection variables inline
[webservers]
node01 ansible_user=root ansible_ssh_private_key_file=~/.ssh/ansible_id

[webservers:vars]
# Group variables: applied to all hosts in webservers
http_port=80
app_name=myapp

[all:vars]
# Variables for ALL hosts
ansible_python_interpreter=/usr/bin/python3
EOF
cat ~/ansible-lab/hosts
```{{execute}}

```bash
# Show parsed inventory
ansible-inventory -i ~/ansible-lab/hosts --list
```{{execute}}

```bash
# Visual tree view
ansible-inventory -i ~/ansible-lab/hosts --graph
```{{execute}}

## Common inventory variables

```bash
cat << 'EOF'
Connection variables:
  ansible_host               <- IP or DNS (if hostname != connection address)
  ansible_port               <- SSH port (default: 22)
  ansible_user               <- SSH login user
  ansible_password           <- SSH password (not recommended, use keys)
  ansible_ssh_private_key_file <- path to private key
  ansible_python_interpreter <- Python path on managed node
  ansible_become             <- enable privilege escalation (sudo)
  ansible_become_user        <- user to become (default: root)
EOF
```{{execute}}
