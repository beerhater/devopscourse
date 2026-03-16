#!/bin/bash
if [ -d "/root/devops_project" ]; then
  exit 0
else
  echo "Директория devops_project не найдена. Попробуйте: mkdir devops_project"
  exit 1
fi
