## Работаем с PATH, which и type

Если каталог есть в `PATH`, команды из него можно запускать без полного пути.

Подготовьте свою маленькую утилиту и добавьте её каталог в `PATH`:

```bash
cat > /opt/env-lab/bin/deploy-report <<'EOF'
#!/bin/bash
echo "release ok"
EOF

chmod +x /opt/env-lab/bin/deploy-report

export PATH="/opt/env-lab/bin:$PATH"

which deploy-report > /root/deploy_report_path.txt
type deploy-report > /root/deploy_report_type.txt
deploy-report > /root/deploy_report_output.txt

cat /root/deploy_report_path.txt
cat /root/deploy_report_type.txt
cat /root/deploy_report_output.txt
```{{execute}}

Разница:

- `which` показывает путь до команды;
- `type` дополнительно показывает, что это за сущность: alias, builtin или обычный исполняемый файл.
