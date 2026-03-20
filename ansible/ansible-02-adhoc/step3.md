# Step 3: -m apt - package management

The `apt` module manages packages on Debian/Ubuntu systems.
It is IDEMPOTENT: running it twice gives the same result.

## Install packages

```bash
cd ~/ansible-lab

# Install nginx
ansible all -b -m apt -a "name=nginx state=present update_cache=yes"
```{{execute}}

```bash
# Verify nginx is installed
ansible all -m shell -a "nginx -v"
```{{execute}}

```bash
# Install multiple packages
ansible all -b -m apt -a "name=curl,wget,tree state=present"
```{{execute}}

## Package states

```bash
cat << 'EOF'
state=present    install if not installed (do nothing if already there)
state=latest     install OR upgrade to latest version
state=absent     remove the package
state=build-dep  install build dependencies
EOF
```{{execute}}

```bash
# Idempotency: running again does nothing (changed: false)
ansible all -b -m apt -a "name=nginx state=present"
```{{execute}}

## Update package cache

```bash
# update_cache=yes: like apt-get update
ansible all -b -m apt -a "update_cache=yes"
```{{execute}}

```bash
# update_cache with cache_valid_time: skip update if cache is fresh
ansible all -b -m apt -a "update_cache=yes cache_valid_time=3600"
```{{execute}}

## Remove packages

```bash
# Remove a package
ansible all -b -m apt -a "name=tree state=absent"
```{{execute}}

```bash
# purge: remove + delete config files
ansible all -b -m apt -a "name=tree state=absent purge=yes"
```{{execute}}

## Upgrade all packages

```bash
# upgrade=safe: like apt-get upgrade (no dependency removals)
ansible all -b -m apt -a "upgrade=safe update_cache=yes" -o
```{{execute}}
