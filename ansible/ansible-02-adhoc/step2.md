# Step 2: -m command and -m shell

These are the most common modules for running arbitrary commands.

## -m command (default module)

```bash
cd ~/ansible-lab

# command is the DEFAULT module - -m command can be omitted
ansible all -m command -a "uptime"
```{{execute}}

```bash
# Same as above (default module)
ansible all -a "uptime"
```{{execute}}

```bash
ansible all -a "hostname"
ansible all -a "id"
ansible all -a "cat /etc/os-release"
```{{execute}}

```bash
# Get free memory
ansible all -a "free -h"
```{{execute}}

## -m command limitations

```bash
# command does NOT use shell - no pipes, no redirects, no env vars
ansible all -m command -a "echo hello | tr a-z A-Z" 2>&1 || true
echo "command module cannot use pipes - use shell module instead"
```{{execute}}

## -m shell: full shell features

```bash
# shell runs through /bin/sh - supports pipes, redirects, variables
ansible all -m shell -a "echo hello | tr a-z A-Z"
```{{execute}}

```bash
ansible all -m shell -a "df -h | grep -E 'Size|/$'"
```{{execute}}

```bash
ansible all -m shell -a "ls /etc/*.conf | wc -l"
```{{execute}}

```bash
# chdir: change directory before running
ansible all -m shell -a "ls -la chdir=/etc/ssh"
```{{execute}}

```bash
# creates: skip if file already exists (idempotency)
ansible all -m shell -a "echo 'created' > /tmp/testfile creates=/tmp/testfile"
ansible all -m shell -a "echo 'created' > /tmp/testfile creates=/tmp/testfile"
echo "Second run skipped (file already exists)"
```{{execute}}

## -m raw: when Python is not available

```bash
# raw bypasses the module system - pure SSH command
# Use for: bootstrapping, minimal containers, network devices
ansible all -m raw -a "uname -r"
```{{execute}}
