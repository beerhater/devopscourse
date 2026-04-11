# Шаг 4: Запись значений через GITHUB_ENV

Иногда значение вычисляется в одном шаге, а нужно в следующем.

```bash
cat > /root/cicd_github_env.yml <<'EOF'
- name: Export runtime variable
  run: echo "IMAGE_TAG=build-42" >> $GITHUB_ENV

- name: Use runtime variable
  run: echo "$IMAGE_TAG"
EOF

cat /root/cicd_github_env.yml
```{{execute}}
