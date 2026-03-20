# Шаг 3: Цикл Refresh — как Terraform сравнивает состояния

## Три состояния которые сравнивает Terraform

```bash
cat << 'EOF'
При каждом terraform plan/apply происходит:

  1. DESIRED STATE  (.tf файлы)
     "Я хочу local_file с content=X и filename=Y"

  2. KNOWN STATE  (terraform.tfstate)
     "В прошлый раз я создал файл с такими атрибутами"

  3. ACTUAL STATE  (реальный мир / API провайдера)
     "А что реально есть прямо сейчас?"

  Terraform сравнивает 1 vs 3 с учётом 2:
    3 == 2 и 1 == 2  -> No changes
    3 != 2           -> Drift! Обновить state
    1 != 2           -> Нужно применить изменения
EOF
```{{execute}}

## terraform refresh — обновить state из реального мира

```bash
cd ~/tf-state
echo "=== До refresh ==="
cat terraform.tfstate | jq '.resources[] | select(.type == "local_file") | .instances[].attributes.content_md5'
```{{execute}}

```bash
# Меняем файл руками (симулируем изменение вне Terraform)
echo "CHANGED MANUALLY" > /tmp/tf-state-demo/server.conf
```{{execute}}

```bash
# terraform refresh обновит state чтобы отразить реальность
terraform refresh
```{{execute}}

```bash
# Terraform увидел изменение и предложит исправить
terraform plan
```{{execute}}

```bash
cat << 'EOF'
ВАЖНО: terraform refresh устарел в Terraform >= 0.15
Вместо него:
  terraform apply -refresh-only      <- обновить state без apply
  terraform plan -refresh-only       <- посмотреть drift
  terraform apply -refresh=false     <- пропустить refresh (быстрее, но опасно)

Refresh происходит автоматически при каждом plan/apply.
EOF
```{{execute}}

## -refresh-only: только обновить state

```bash
# Видим что изменилось снаружи — принять эти изменения в state
terraform apply -refresh-only -auto-approve
```{{execute}}

```bash
# Или восстановить состояние по .tf файлам
terraform apply -auto-approve
cat /tmp/tf-state-demo/server.conf
```{{execute}}
