# Step 1: Ad-hoc syntax and patterns

## Full syntax

```bash
ansible <pattern> -m <module> -a "<args>" [options]

Options:
  -i inventory     use specific inventory file
  -u user          SSH user (overrides ansible.cfg)
  -b               become (sudo)
  --become-user    user to become (default root)
  -k               ask for SSH password
  -v/-vv/-vvv      verbosity
  -f N             fork N parallel processes (default 5)
  -o               one-line condensed output
  -C               check mode (dry-run, no changes)
  --diff           show file diffs
```{{execute}}

## Patterns - who to target

```bash
cd ~/ansible-lab

# All hosts
ansible all -m ping

# Specific group
ansible webservers -m ping

# Specific host by name
ansible node01 -m ping
```{{execute}}

```bash
# Wildcard
ansible 'node*' -m ping
```{{execute}}

```bash
# Negation: all except
ansible 'all,!node01' -m ping 2>/dev/null || echo "No other hosts (expected)"
```{{execute}}

## -o flag: compact one-line output

```bash
cd ~/ansible-lab
ansible all -m ping -o
```{{execute}}

## Check mode: dry-run before applying

```bash
# -C: simulate without making changes (not all modules support it)
ansible all -m command -a "uptime" -C
```{{execute}}
