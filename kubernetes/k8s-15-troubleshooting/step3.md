# Шаг 3: Сохраняем ключевые events

Теперь вытащим из `describe` только ключевые события вокруг image pull проблемы.

```bash
grep -E 'ErrImagePull|ImagePullBackOff|Failed to pull image' /root/broken_pod_describe.txt > /root/broken_events.txt || true
cat /root/broken_events.txt
```{{execute}}
