## Сохраняем переменную в .bashrc

Если настройка нужна не на один запуск, а постоянно, её часто кладут в shell profile.

Добавьте переменную в `~/.bashrc`, затем перечитайте файл:

```bash
grep -q 'export COURSE_PROFILE=linux-devops' ~/.bashrc || echo 'export COURSE_PROFILE=linux-devops' >> ~/.bashrc

source ~/.bashrc
printenv COURSE_PROFILE > /root/course_profile.txt
cat /root/course_profile.txt
```{{execute}}

Так делают для:

- удобных переменных;
- кастомного `PATH`;
- aliases и функций;
- повторяемой среды в терминале.
