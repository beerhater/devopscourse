# Шаг 5: Сравниваем QoS классы

Сведите два pod в одну короткую таблицу.

```bash
{
  echo "resource-demo $(cat /root/resource_qos.txt)"
  echo "guaranteed-demo $(cat /root/guaranteed_qos.txt)"
} > /root/qos_compare.txt

cat /root/qos_compare.txt
```{{execute}}
