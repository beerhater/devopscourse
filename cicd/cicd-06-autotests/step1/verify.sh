#!/bin/bash
cd /opt/autotests-demo && python3 -c "from bank import BankAccount; BankAccount('test', 100); print('OK')"
