#!/bin/bash
! docker ps -a --format '{{.Names}}' | grep -q "^container-a$"
