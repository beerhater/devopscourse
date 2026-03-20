# Step 8: YAML inventory format

INI is simple but YAML is more powerful for complex inventories.

## Convert our inventory to YAML

```bash
cat > ~/ansible-lab/hosts.yml << 'EOF'
all:
  vars:
    ansible_python_interpreter: /usr/bin/python3

  children:
    webservers:
      hosts:
        node01:
          http_port: 80
          server_name: web01.lab
      vars:
        nginx_version: "1.25"
        deploy_path: /var/www/html

    databases:
      hosts: {}   # empty group

    production:
      children:
        webservers:
        databases:
      vars:
        env: production
EOF
cat ~/ansible-lab/hosts.yml
```{{execute}}

```bash
cd ~/ansible-lab
# Use YAML inventory explicitly
ansible-inventory -i hosts.yml --graph
```{{execute}}

```bash
ansible-inventory -i hosts.yml --host node01
```{{execute}}

```bash
# Ping using YAML inventory
ansible all -i hosts.yml -m ping
```{{execute}}

## INI vs YAML comparison

```bash
cat << 'EOF'
INI format:
  + Simple, quick to write
  + Good for small inventories
  - Limited nesting
  - Vars only as strings

YAML format:
  + Proper data types (int, bool, list)
  + Deep nesting (group of groups of groups)
  + Version-control friendly (clean diffs)
  + Same syntax as playbooks
  - More verbose

Recommendation:
  Small lab      -> INI is fine
  Production     -> YAML + host_vars/ + group_vars/
EOF
```{{execute}}

```bash
# Update ansible.cfg to use YAML inventory
sed -i 's/inventory = .\/hosts/inventory = .\/hosts.yml/' ~/ansible-lab/ansible.cfg
cat ~/ansible-lab/ansible.cfg | grep inventory
```{{execute}}

```bash
cd ~/ansible-lab
ansible all -m ping
```{{execute}}
