## Быстрая сводка по системе

Когда вы впервые заходите на сервер, полезно быстро понять:

- что за система перед вами;
- сколько у неё CPU;
- как давно она работает.

Сохраните базовую сводку в отдельные файлы:

```bash
uname -a > /root/system_uname.txt
uptime > /root/system_uptime.txt
nproc > /root/system_cpus.txt

cat /root/system_uname.txt
cat /root/system_uptime.txt
cat /root/system_cpus.txt
```{{execute}}

Это простой стартовый triage перед более глубокой диагностикой.
