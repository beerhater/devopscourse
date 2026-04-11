# Шаг 5: Сравниваем политики в одном отчёте

Соберите короткую таблицу, чтобы визуально сравнить все варианты.

```bash
{
  echo "restart-demo $(cat /root/restart_policy.txt)"
  echo "restart-none $(cat /root/restart_none_policy.txt)"
  echo "restart-unless $(cat /root/restart_unless_policy.txt)"
  echo "restart-always $(cat /root/restart_always_policy.txt)"
} > /root/restart_policy_matrix.txt

cat /root/restart_policy_matrix.txt
```{{execute}}

Такой отчёт помогает быстро объяснить команде, чем именно отличаются политики.
