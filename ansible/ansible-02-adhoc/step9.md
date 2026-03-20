# Step 9: Useful patterns and output control

## -o: one-line output

```bash
cd ~/ansible-lab

# Compact view for many hosts
ansible all -m setup -a "filter=ansible_hostname" -o
ansible all -m command -a "uptime" -o
```{{execute}}

## Parallel execution with -f

```bash
# -f 10: run on 10 hosts in parallel (default 5)
# useful when you have many hosts
ansible all -m ping -f 10
```{{execute}}

## Register and use return values

```bash
cat << 'EOF'
Ad-hoc cannot register variables (that is playbook feature)
But you can see raw return JSON with -v

ansible all -m command -a "uptime" -v
  shows: rc (return code), stdout, stderr, start, end, delta
EOF
```{{execute}}

```bash
ansible all -m command -a "uptime" -v 2>&1 | grep -E 'rc|stdout|changed'
```{{execute}}

## Failed when / ignore errors

```bash
# By default: non-zero exit code = FAILED
ansible all -m shell -a "ls /nonexistent" 2>&1 | head -5 || true
```{{execute}}

```bash
# failed_when equivalent in ad-hoc: not available
# Use shell and redirect to always succeed
ansible all -m shell -a "ls /nonexistent 2>/dev/null || echo not found"
```{{execute}}

## Become (sudo) patterns

```bash
# -b: become root
ansible all -b -m shell -a "whoami"
```{{execute}}

```bash
# --become-user: become specific user (not root)
ansible all -b --become-user=deploy -m shell -a "whoami" 2>/dev/null || ansible all -b -m shell -a "sudo -u deploy whoami 2>/dev/null || echo deploy-user"
```{{execute}}

## Quick server inventory check

```bash
# Gather multiple facts in one pass
ansible all -m setup -a "filter=ansible_hostname,ansible_memtotal_mb,ansible_processor_vcpus,ansible_distribution" -o 2>/dev/null | head -5
ansible all -m setup -a "filter=ansible_distribution"
```{{execute}}
