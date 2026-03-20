# Ansible Ad-hoc Commands

Ad-hoc commands let you run a single Ansible module directly from the CLI --
no playbook needed. Perfect for quick tasks, checks, and one-off operations.

```
ansible <pattern> -m <module> -a "<arguments>"
         |          |           |
    who to target  module    module args
```

## What we will learn

- Ad-hoc syntax and patterns
- -m command and -m shell: run arbitrary commands
- -m apt: install, remove, update packages
- -m copy and -m template: push files to remote
- -m file: manage permissions, dirs, symlinks
- -m service: start, stop, enable, disable
- -m user and -m group: manage OS users
- -m fetch: pull files FROM remote to control node
- -m lineinfile and -m replace: edit files in place
- Final task: provision a web server using only ad-hoc

> Check setup: `cd ~/ansible-lab && ansible all -m ping`{{execute}}
