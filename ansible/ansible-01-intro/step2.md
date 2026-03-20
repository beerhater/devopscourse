# Step 2: Explore the lab environment

## Two nodes, one network

```bash
echo "=== Control Node ===" && hostname && ip addr show eth0 | grep 'inet '
```{{execute}}

```bash
echo "=== Managed Node ===" && ssh root@node01 "hostname && ip addr show eth0 | grep 'inet '"
```{{execute}}

```bash
# Both nodes can see each other by hostname
ping -c 2 node01
```{{execute}}

```bash
# Python3 is available on managed node (Ansible requirement)
ssh root@node01 "python3 --version && which python3"
```{{execute}}

```bash
# SSH server is running on node01 (Ansible connects here)
ssh root@node01 "systemctl is-active ssh || systemctl is-active sshd"
```{{execute}}

## What Ansible needs on a managed node

```bash
cat << 'EOF'
Requirements on managed node:
  [x] Python 3      -- to run Ansible modules
  [x] SSH server    -- so Ansible can connect
  [x] Valid user    -- root or user with sudo
  [ ] Ansible       -- NOT required

That is it. No agent. No daemon. No installation.
EOF
```{{execute}}

```bash
# SSH is already configured between nodes in this lab
# This is what Ansible will use under the hood
ssh root@node01 "echo 'SSH connection works! Node01 is reachable.'"
```{{execute}}
