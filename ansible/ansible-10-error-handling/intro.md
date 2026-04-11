## Ansible: Block, Rescue, Always

Иногда задача падает, но playbook должен:

- аккуратно отреагировать;
- записать recovery marker;
- выполнить cleanup в любом случае.

Для этого и нужны `block`, `rescue` и `always`.
