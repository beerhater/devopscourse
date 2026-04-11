## Смотрим блоковые устройства и mount points

Следующий полезный уровень диагностики:

- какие есть устройства;
- как они называются;
- куда смонтированы файловые системы.

```bash
lsblk > /root/lsblk_report.txt
mount | head -n 20 > /root/mount_report.txt

cat /root/lsblk_report.txt
cat /root/mount_report.txt
```{{execute}}

Это помогает понять, что именно вы смотрите: локальный диск, overlay, отдельный mount или дополнительный volume.
