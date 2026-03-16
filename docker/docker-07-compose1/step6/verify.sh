#!/bin/bash
test -f /opt/compose-intro/.env && cd /opt/compose-intro && docker-compose ps | grep -q "db"
