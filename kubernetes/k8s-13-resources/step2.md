# Шаг 2: Читаем describe и секции ресурсов

`kubectl describe` показывает ресурсы так, как их увидит человек при triage.

```bash
kubectl describe pod resource-demo > /root/resource_describe_full.txt
grep -nE 'Requests:|Limits:' /root/resource_describe_full.txt > /root/resource_describe_sections.txt
cat /root/resource_describe_sections.txt
```{{execute}}
