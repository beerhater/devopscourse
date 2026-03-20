# Step 5: -m file - manage files, dirs, permissions, symlinks

The `file` module manages file attributes without copying content.

## Create directories

```bash
cd ~/ansible-lab

# Create a directory
ansible all -b -m file -a "path=/opt/myapp state=directory"
```{{execute}}

```bash
# Create with specific permissions
ansible all -b -m file -a "path=/opt/myapp/logs state=directory owner=root group=root mode=0755"
```{{execute}}

```bash
ansible all -m shell -a "ls -la /opt/"
```{{execute}}

## File states

```bash
cat << 'EOF'
state=file        ensure file exists (does not create, only manages attrs)
state=directory   ensure directory exists (creates if missing)
state=link        create symbolic link
state=hard        create hard link
state=touch       create empty file if missing (like touch)
state=absent      remove file/dir/link
EOF
```{{execute}}

## Create files and symlinks

```bash
# Create empty file
ansible all -b -m file -a "path=/opt/myapp/app.log state=touch"
```{{execute}}

```bash
# Create symlink
ansible all -b -m file -a "src=/opt/myapp path=/var/myapp state=link"
```{{execute}}

```bash
ansible all -m shell -a "ls -la /var/myapp && ls -la /opt/myapp/"
```{{execute}}

## Change permissions recursively

```bash
# recurse=yes: apply to all files/dirs inside
ansible all -b -m file -a "path=/opt/myapp owner=root group=root mode=0755 recurse=yes"
```{{execute}}

```bash
ansible all -m shell -a "ls -la /opt/myapp/"
```{{execute}}

## Remove files and directories

```bash
# Remove symlink
ansible all -b -m file -a "path=/var/myapp state=absent"
```{{execute}}

```bash
# Remove directory and all contents
ansible all -b -m file -a "path=/opt/myapp state=absent"
```{{execute}}
