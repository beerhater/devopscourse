# Step 6: First ansible ping

`ansible all -m ping` is the Ansible "hello world".
It tests: inventory parsing + SSH connection + Python on remote.

```
ping module does NOT send ICMP ping
It connects via SSH, imports Python, returns {"ping": "pong"}
```

## Run the first ping

```bash
cd ~/ansible-lab
ansible all -m ping
```{{execute}}

```bash
# Ping specific group
ansible webservers -m ping
```{{execute}}

```bash
# Verbose output - see exactly what SSH connection is made
ansible all -m ping -v
```{{execute}}

```bash
# Very verbose - see all SSH parameters
ansible all -m ping -vvv 2>&1 | head -40
```{{execute}}

## Understanding the output

```bash
cat << 'EOF'
node01 | SUCCESS => {
    "changed": false,     <- no change was made on host
    "ping": "pong"        <- module ran successfully
}

node01 | FAILED!          <- connection failed
  ...permission denied    <- SSH auth issue
  ...no hosts matched     <- inventory issue
  ...python not found     <- Python missing on remote
EOF
```{{execute}}

```bash
# ping a specific host by name
ansible node01 -m ping
```{{execute}}

```bash
# Run against all except one host (useful with many nodes)
ansible 'all,!node01' -m ping 2>/dev/null || echo "No other hosts (expected in 2-node lab)"
```{{execute}}

## -m ping vs actual connectivity test

```bash
# ansible ping = SSH + Python test
ansible all -m ping

# To test actual network: use raw module (no Python needed)
ansible all -m raw -a "echo hello from raw"
```{{execute}}
