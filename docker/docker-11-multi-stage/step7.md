# Шаг 7: Собираем отчёт по multi-stage-пайплайну

Сделайте короткую сводку по итогам урока.

```bash
{
  echo "builder=$(cat /root/multistage_builder_image.txt)"
  echo "runtime_file=$(cat /root/multistage_release.txt)"
  echo "runtime_file_v2=$(cat /root/multistage_release_v2.txt)"
} > /root/multistage_final_report.txt

cat /root/multistage_final_report.txt
```{{execute}}
