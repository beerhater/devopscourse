#!/bin/bash
cd /opt/compose-intro && docker-compose ps | grep -q "db"
