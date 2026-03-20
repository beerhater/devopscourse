# Step 3: SSH keys - how Ansible authenticates

Ansible connects via SSH. By default it uses SSH key authentication.
Understanding SSH keys is critical before using Ansible.

## How SSH key auth works

```
1. You generate a key PAIR: private key + public key
   id_rsa (private) -- NEVER share this
   id_rsa.pub (public) -- copy this to servers

2. Copy public key to managed node:
   ~/.ssh/authorized_keys on node01

3. Connect: SSH proves you own the private key
   No password needed
```

## Check existing SSH setup in this lab

```bash
# Does a key pair already exist on controlplane?
ls -la ~/.ssh/
```{{execute}}

```bash
cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "No key yet"
```{{execute}}

```bash
# Check authorized_keys on node01
ssh root@node01 "cat ~/.ssh/authorized_keys 2>/dev/null | head -2 || echo 'Empty'"
```{{execute}}

## Generate a dedicated Ansible SSH key

```bash
# Best practice: separate key for Ansible automation
ssh-keygen -t ed25519 -C "ansible-control" -f ~/.ssh/ansible_id -N ""
```{{execute}}

```bash
ls -la ~/.ssh/
echo ""
echo "Private key: ~/.ssh/ansible_id"
echo "Public key:  ~/.ssh/ansible_id.pub"
cat ~/.ssh/ansible_id.pub
```{{execute}}

## Deploy public key to node01

```bash
# ssh-copy-id copies the public key to remote authorized_keys
ssh-copy-id -i ~/.ssh/ansible_id.pub root@node01
```{{execute}}

```bash
# Verify key was added
ssh root@node01 "tail -1 ~/.ssh/authorized_keys"
```{{execute}}

```bash
# Test key-based auth explicitly
ssh -i ~/.ssh/ansible_id root@node01 "echo 'Key auth works! No password needed.'"
```{{execute}}

## SSH key types comparison

```bash
cat << 'EOF'
RSA (id_rsa)        -- classic, 2048+ bits, widely supported
ECDSA (id_ecdsa)    -- smaller, faster, elliptic curve
Ed25519 (id_ed25519)-- newest, best security/performance, use this

For Ansible: Ed25519 recommended for new setups
EOF
```{{execute}}
