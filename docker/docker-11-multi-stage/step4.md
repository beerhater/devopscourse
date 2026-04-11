# Шаг 4: Смотрим историю слоёв

История образа помогает понять, какие шаги реально попали в финальный image.

```bash
docker history multistage-demo:v1 --no-trunc | head -n 10 > /root/multistage_history.txt
cat /root/multistage_history.txt
```{{execute}}

Это полезно для аудита, оптимизации и поиска лишних слоёв.
