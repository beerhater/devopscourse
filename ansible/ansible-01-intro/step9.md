# Step 9: Useful ping variations and gathering facts

## ansible -m setup - gather facts from hosts

```bash
cd ~/ansible-lab
# setup module collects ALL facts about remote host
ansible all -m setup 2>/dev/null | head -50
```{{execute}}

```bash
# Filter facts by pattern
ansible all -m setup -a "filter=ansible_os_family"
```{{execute}}

```bash
ansible all -m setup -a "filter=ansible_distribution*"
```{{execute}}

```bash
ansible all -m setup -a "filter=ansible_memtotal_mb"
```{{execute}}

```bash
ansible all -m setup -a "filter=ansible_processor_vcpus"
```{{execute}}

## Facts you will use in playbooks

```bash
cat << 'EOF'
ansible_hostname           <- short hostname
ansible_fqdn               <- fully qualified domain name
ansible_os_family          <- "Debian", "RedHat", "Suse"
ansible_distribution       <- "Ubuntu", "CentOS", "Debian"
ansible_distribution_version <- "22.04", "9", etc
ansible_default_ipv4.address <- primary IP
ansible_memtotal_mb        <- total RAM in MB
ansible_processor_vcpus    <- number of CPU cores
ansible_env.HOME           <- home directory
ansible_date_time.date     <- current date on remote
EOF
```{{execute}}

```bash
# Get specific network facts
ansible all -m setup -a "filter=ansible_default_ipv4"
```{{execute}}

## ansible -m command vs -m shell vs -m raw

```bash
cat << 'EOF'
-m raw      no Python needed, runs SSH command directly
            use for: bootstrap, Windows, minimal systems

-m command  default module, runs command WITHOUT shell
            no pipes, no redirection, no env vars
            use for: simple commands

-m shell    runs command THROUGH /bin/sh
            supports: pipes | redirects > variables $VAR
            use for: complex commands
EOF
```{{execute}}

```bash
# command: no shell features
ansible all -m command -a "hostname"
```{{execute}}

```bash
# shell: supports pipes and shell features
ansible all -m shell -a "hostname | tr a-z A-Z"
```{{execute}}

```bash
# raw: no Python, direct SSH
ansible all -m raw -a "uname -r"
```{{execute}}
