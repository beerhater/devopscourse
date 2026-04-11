# Шаг 5: Добавляем .dockerignore

Даже при multi-stage полезно исключать лишние файлы из build context.

```bash
cd /opt/docker-multistage
cat > .dockerignore <<'EOF'
*.log
tmp/
EOF

cat .dockerignore > /root/multistage_dockerignore.txt
cat /root/multistage_dockerignore.txt
```{{execute}}

Это уменьшает контекст сборки и снижает шанс случайно протащить мусор в image build.
