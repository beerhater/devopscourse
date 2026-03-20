# Шаг 5: for_each с модулями

`for_each` позволяет создать N экземпляров модуля из коллекции.

## for_each — создаём модули из map

```bash
cd ~/tf-modules
```{{execute}}

```bash
cat > main.tf << 'EOF'
locals {
  # Описываем все окружения в одном месте
  environments = {
    dev = {
      port     = 3000
      replicas = 1
      extra_vars = { DEBUG = "true" }
    }
    staging = {
      port     = 8080
      replicas = 2
      extra_vars = { STAGING = "true" }
    }
    production = {
      port     = 8080
      replicas = 3
      extra_vars = { SENTRY = "https://sentry.io/1" }
    }
  }
}

# Один вызов = три окружения!
module "app" {
  for_each = local.environments
  source   = "./modules/app-config"

  project        = "cr-it"
  environment    = each.key            # "dev", "staging", "production"
  app_port       = each.value.port
  extra_env_vars = each.value.extra_vars
}

module "nginx" {
  for_each = local.environments
  source   = "./modules/nginx-config"

  server_name   = module.app[each.key].app_name
  upstream_port = each.value.port
  environment   = each.key
  output_dir    = "/tmp/modules-foreach"
}
EOF
```{{execute}}

```bash
cat > outputs.tf << 'EOF'
# Собираем все deploy_id в map
output "deploy_ids" {
  value = {for env, mod in module.app : env => mod.deploy_id}
}

# Все пути к конфигам
output "config_paths" {
  value = {for env, mod in module.app : env => mod.config_path}
}

# Nginx upstreams
output "nginx_upstreams" {
  value = {for env, mod in module.nginx : env => mod.upstream}
}
EOF
```{{execute}}

```bash
terraform init && terraform apply -auto-approve
```{{execute}}

```bash
echo "=== OUTPUTS ==="
terraform output -json | jq .

echo ""
echo "=== ВСЕ КОНФИГИ ==="
find /tmp/modules-foreach -name "*.conf" | sort | while read f; do
  echo "--- $f ---"
  cat "$f"
  echo ""
done
```{{execute}}

## Адресация ресурсов for_each модуля

```bash
cat << 'EOF'
При for_each модуль адресуется через ключ:

  terraform state list | grep module.app
    module.app["dev"].random_id.deploy_id
    module.app["dev"].local_file.app_config
    module.app["staging"].random_id.deploy_id
    module.app["production"].random_id.deploy_id

  terraform state show module.app["dev"].random_id.deploy_id

  terraform apply -target=module.app["production"]
  terraform destroy -target=module.nginx["staging"]
EOF
```{{execute}}

```bash
terraform state list | grep 'module\.'
```{{execute}}
