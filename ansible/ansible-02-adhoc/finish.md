# Module complete!

## What we learned

- **Ad-hoc syntax** -- `ansible <pattern> -m <module> -a <args>`
- **-m command** -- default module, no shell features, safe
- **-m shell** -- full shell: pipes, redirects, env vars
- **-m raw** -- bypass Python, pure SSH (bootstrap use case)
- **-m apt** -- install/remove/upgrade packages, idempotent
- **-m copy** -- push files with permissions, backup, content=
- **-m file** -- manage dirs, symlinks, permissions, state=absent
- **-m service / systemd** -- start, stop, enable, reload
- **-m user / group** -- create OS users with keys
- **-m fetch** -- pull files FROM remote to control node
- **-m lineinfile** -- add/remove/replace lines in files
- **-m replace** -- regex substitution across files

## Quick Reference

```bash
ansible all -m ping
ansible all -m command -a 'uptime'
ansible all -m shell -a 'df -h | grep /'
ansible all -b -m apt -a 'name=nginx state=present update_cache=yes'
ansible all -b -m copy -a 'src=file.txt dest=/tmp/file.txt'
ansible all -b -m copy -a 'content=hello dest=/tmp/f'
ansible all -b -m file -a 'path=/opt/app state=directory mode=0755'
ansible all -b -m service -a 'name=nginx state=started enabled=yes'
ansible all -b -m user -a 'name=deploy state=present create_home=yes'
ansible all -b -m fetch -a 'src=/etc/hostname dest=/tmp/ flat=yes'
ansible all -b -m lineinfile -a 'path=/etc/hosts line=10.0.0.1 myapp'
```

## Next module

**Playbook Part 1** -- YAML playbooks, tasks, handlers, `notify`, install nginx properly.
