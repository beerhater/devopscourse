# Шаг 3: Проверяем ordinals и имена pod

Сохраните только имена pod, чтобы глазами увидеть ordinals `0`, `1`, `2`.

```bash
kubectl get pods -l app=app-headless -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | sort > /root/stateful_ordinals.txt
cat /root/stateful_ordinals.txt
```{{execute}}
