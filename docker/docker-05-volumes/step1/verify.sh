#!/bin/bash
# Проверяем, что студент понял концепцию — контейнер data-test удалён
! docker ps -a --format '{{.Names}}' | grep -q "^data-test$"
