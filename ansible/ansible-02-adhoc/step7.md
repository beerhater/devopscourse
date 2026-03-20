# Step 7: -m user and -m group - manage OS users

## Create groups

```bash
cd ~/ansible-lab

# Create a group
ansible all -b -m group -a "name=webteam state=present"
```{{execute}}

```bash
# Create with specific GID
ansible all -b -m group -a "name=appgroup gid=1500 state=present"
```{{execute}}

```bash
ansible all -m shell -a "getent group webteam appgroup"
```{{execute}}

## Create users

```bash
# Create a user with home directory
ansible all -b -m user -a "name=deploy comment='Deploy user' state=present create_home=yes"
```{{execute}}

```bash
# Create user with specific UID, group, shell
ansible all -b -m user -a "name=appuser uid=2000 group=webteam groups=sudo shell=/bin/bash state=present"
```{{execute}}

```bash
ansible all -m shell -a "id deploy && id appuser"
```{{execute}}

## User parameters

```bash
cat << 'EOF'
name         username
uid          user ID
group        primary group
groups       additional groups (comma separated)
shell        login shell
home         home directory path
create_home  create home dir (yes/no)
comment      GECOS field (full name)
password     hashed password (use password_hash filter)
state        present / absent
system       yes = system account (no home, no login)
EOF
```{{execute}}

## Set SSH key for user

```bash
# authorized_key module: add SSH public key to user
ansible all -b -m authorized_key -a "user=deploy key='$(cat ~/.ssh/ansible_id.pub)' state=present"
```{{execute}}

```bash
ansible all -m shell -a "cat /home/deploy/.ssh/authorized_keys"
```{{execute}}

## Remove users

```bash
# remove=yes: also delete home directory and mail spool
ansible all -b -m user -a "name=appuser state=absent remove=yes"
```{{execute}}
