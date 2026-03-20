# Ansible Introduction: inventory, SSH keys, first ping

Ansible is an agentless automation tool.
No agents to install on managed nodes -- it connects via SSH and runs modules remotely.

```
Control Node (controlplane)     Managed Node (node01)
  ansible installed         SSH  no ansible needed
  inventory file       -------->  Python 3 only
  playbooks                       port 22 open
```

## What we will learn

- Ansible architecture: control node vs managed nodes
- Install Ansible on the control node
- SSH keys: generate, deploy, test
- Inventory file (hosts): INI format, groups, variables
- ansible.cfg: default configuration
- First real command: ansible all -m ping
- Inventory groups and host/group variables
- YAML inventory format
- Final task: build complete inventory from scratch

> Check both nodes: `hostname && echo "---" && ssh node01 hostname 2>/dev/null || echo "node01 reachable via network"`{{execute}}
