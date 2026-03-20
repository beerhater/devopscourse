# Step 1: Ansible architecture and installation

## How Ansible works

```
You run:  ansible all -m ping
              |
              v
  Ansible reads inventory  ->  finds target hosts
  Ansible connects via SSH ->  to each host
  Ansible copies module    ->  /tmp/ansible_xxx.py
  Python runs the module   ->  on remote host
  Result returned via SSH  ->  JSON to control node
  Temp file removed        ->  clean, no agent left behind
```

No daemon. No agent. No open port on managed nodes (only SSH 22).

## Install Ansible

```bash
apt-get update -qq && apt-get install -y python3-pip 2>/dev/null | tail -1
pip3 install ansible --quiet
```{{execute}}

```bash
ansible --version
```{{execute}}

```bash
# Ansible uses Python on both sides
# Control node: Python runs Ansible itself
# Managed node: Python runs the module (most distros have Python3)
python3 --version
echo "Remote Python check:"
ssh node01 python3 --version 2>/dev/null || echo "Will check in next step"
```{{execute}}

## Core components

```bash
cat << 'EOF'
CONTROL NODE:
  ansible         <- main CLI tool (ad-hoc commands)
  ansible-playbook <- runs playbooks
  ansible-galaxy   <- manage roles and collections
  ansible-vault    <- encrypt secrets
  ansible-doc      <- offline documentation

MANAGED NODE requirements:
  - Python 3.x installed
  - SSH server running (port 22)
  - User with sudo OR root access
  - NO Ansible installation needed
EOF
```{{execute}}

```bash
# List all built-in modules (offline docs)
ansible-doc -l | wc -l
echo "built-in modules available offline"
```{{execute}}
