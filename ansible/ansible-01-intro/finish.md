# Module complete!

## What we learned

- **Ansible architecture** -- agentless, SSH-based, Python modules on remote
- **Control node requirements** -- Ansible installed, SSH key, inventory file
- **Managed node requirements** -- Python 3 + SSH server only
- **SSH key generation** -- `ssh-keygen -t ed25519`, `ssh-copy-id`
- **ansible.cfg** -- inventory, remote_user, private_key_file, host_key_checking
- **INI inventory** -- hosts, groups, [group:vars], [group:children]
- **YAML inventory** -- all/children/hosts/vars hierarchy
- **host_vars/ and group_vars/** -- clean variable organization
- **ansible all -m ping** -- connectivity test (SSH + Python, not ICMP)
- **ansible -m setup** -- gather facts, filter with `filter=`
- **raw vs command vs shell** -- when to use each module type

## Quick Reference

```bash
# Generate SSH key
ssh-keygen -t ed25519 -f ~/.ssh/ansible_id -N ''
ssh-copy-id -i ~/.ssh/ansible_id.pub root@node01

# Test connectivity
ansible all -m ping
ansible all -m ping -v

# Gather facts
ansible all -m setup
ansible all -m setup -a 'filter=ansible_distribution*'

# Inspect inventory
ansible-inventory --graph
ansible-inventory --host node01
ansible-inventory --list
```

## Next module

**Ad-hoc commands** -- `ansible all -m shell`, `-m apt`, `-m copy`, `-m service`.
