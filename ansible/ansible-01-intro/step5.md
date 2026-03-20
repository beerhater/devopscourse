# Step 5: ansible.cfg - configuration file

`ansible.cfg` sets defaults so you don't repeat flags on every command.
Ansible searches for it in this order:
`ANSIBLE_CONFIG` env var > `./ansible.cfg` > `~/.ansible.cfg` > `/etc/ansible/ansible.cfg`

## Create ansible.cfg in project directory

```bash
cat > ~/ansible-lab/ansible.cfg << 'EOF'
[defaults]
# Default inventory file (no need for -i flag)
inventory = ./hosts

# Remote user for SSH connections
remote_user = root

# Path to SSH private key
private_key_file = ~/.ssh/ansible_id

# Don't check host fingerprints (useful in lab, NOT in production)
host_key_checking = False

# Python interpreter on managed nodes
interpreter_python = /usr/bin/python3

# Output format
stdout_callback = yaml

# Don't create .retry files
retry_files_enabled = False

[ssh_connection]
# Reuse SSH connections for performance (ControlMaster)
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no
pipelining = True
EOF
cat ~/ansible-lab/ansible.cfg
```{{execute}}

```bash
cd ~/ansible-lab
# Verify ansible picks up the config
ansible --version | grep 'config file'
```{{execute}}

## Simplify inventory now (vars moved to ansible.cfg)

```bash
cat > ~/ansible-lab/hosts << 'EOF'
[webservers]
node01

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
cat ~/ansible-lab/hosts
```{{execute}}

```bash
cd ~/ansible-lab && ansible-inventory --graph
```{{execute}}

## host_key_checking warning

```bash
cat << 'EOF'
host_key_checking = False
  -- Lab only! Disables SSH fingerprint verification
  -- In production: set to True and use known_hosts
  -- Prevents "Are you sure you want to continue connecting?" prompt
  -- Without this: first Ansible run hangs waiting for user input
EOF
```{{execute}}
