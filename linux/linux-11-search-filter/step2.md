## grep и grep -i

`grep` ищет строки по шаблону.
Это один из самых полезных инструментов для DevOps-инженера.

Обычный `grep` чувствителен к регистру, а `grep -i` — нет.

```bash
grep "ERROR" /opt/search-lab/logs/app.log > /root/error_lines.txt
grep -i "timeout" /opt/search-lab/logs/app.log > /root/timeout_lines.txt

cat /root/error_lines.txt
cat /root/timeout_lines.txt
```{{execute}}

Обратите внимание:
- `grep "ERROR"` нашёл только строки с верхним регистром;
- `grep -i "timeout"` нашёл строку, даже если слово записано не так же, как в запросе.

Это очень помогает, когда логи пишут разные приложения в разном стиле.
