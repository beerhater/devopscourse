#!/bin/bash
! docker ps -a --format '{{.Names}}' | grep -q "^full-demo$"
