# Шаг 3: Step-level env

Если значение нужно только одной команде, лучше держать его на уровне шага.

```bash
cat > /root/cicd_step_env.yml <<'EOF'
- name: Run one step with env
  env:
    RELEASE_COLOR: green
  run: echo "$RELEASE_COLOR"
EOF

cat /root/cicd_step_env.yml
```{{execute}}
