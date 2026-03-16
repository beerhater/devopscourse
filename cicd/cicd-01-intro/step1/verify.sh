#!/bin/bash
test -f /opt/myapp/app.py && python3 /opt/myapp/app.py | grep -q "Приложение работает"
