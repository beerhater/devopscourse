# Step 8: -m fetch and -m lineinfile

## -m fetch: download files FROM remote to control node

The opposite of copy: pull files from managed nodes to control node.

```bash
cd ~/ansible-lab

# Fetch a file from remote
ansible all -b -m fetch -a "src=/etc/hostname dest=/tmp/fetched/"
```{{execute}}

```bash
# File saved as: dest/<hostname>/src path
ls -la /tmp/fetched/
find /tmp/fetched -type f
cat /tmp/fetched/node01/etc/hostname
```{{execute}}

```bash
# flat=yes: no subdirectory - just save the file directly
ansible all -b -m fetch -a "src=/etc/os-release dest=/tmp/node01-os-release flat=yes"
cat /tmp/node01-os-release | head -5
```{{execute}}

```bash
# Useful: fetch logs for debugging
ansible all -b -m fetch -a "src=/var/log/syslog dest=/tmp/logs/ flat=no" 2>/dev/null | head -5 || ansible all -b -m fetch -a "src=/var/log/auth.log dest=/tmp/logs/ flat=no" 2>/dev/null | head -5 || echo "Fetched system log"
```{{execute}}

## -m lineinfile: add/modify lines in files

```bash
# Ensure a line EXISTS in a file
ansible all -b -m lineinfile -a "path=/etc/hosts line='10.0.0.100 myapp.local' state=present"
```{{execute}}

```bash
ansible all -m shell -a "grep myapp /etc/hosts"
```{{execute}}

```bash
# Replace line matching a regex
ansible all -b -m lineinfile -a "path=/etc/hosts regexp='myapp.local' line='10.0.0.200 myapp.local' state=present"
ansible all -m shell -a "grep myapp /etc/hosts"
```{{execute}}

```bash
# Remove a line
ansible all -b -m lineinfile -a "path=/etc/hosts regexp='myapp.local' state=absent"
ansible all -m shell -a "grep myapp /etc/hosts || echo removed"
```{{execute}}

## -m replace: regex substitution across whole file

```bash
# Create test file
ansible all -b -m copy -a "content='env=development
debug=true
port=8080
' dest=/tmp/app.cfg"
```{{execute}}

```bash
# Replace all occurrences of a pattern
ansible all -b -m replace -a "path=/tmp/app.cfg regexp='development' replace='production'"
ansible all -m command -a "cat /tmp/app.cfg"
```{{execute}}
