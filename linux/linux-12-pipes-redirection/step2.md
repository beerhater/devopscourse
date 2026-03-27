## Перезапись и дозапись через > и >>

`>` перезаписывает файл целиком.
`>>` дописывает строку в конец, не стирая старое содержимое.

```bash
echo "deploy started" > /root/deploy_notes.log
echo "nginx checked" >> /root/deploy_notes.log
echo "config validated" >> /root/deploy_notes.log

cat /root/deploy_notes.log
```{{execute}}

Это встречается постоянно:
- писать короткие отчёты;
- собирать ручной changelog;
- дописывать audit trail в лог-файл.
