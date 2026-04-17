# Шаг 1: Установка Terraform

```bash
apt-get update -qq && apt-get install -y -qq gnupg curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor   -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]   https://apt.releases.hashicorp.com $(lsb_release -cs) main"   | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -qq && apt-get install -y terraform
terraform version
```{{execute}}

## Создаём учебный проект

```bash
mkdir -p ~/tf-commands && cd ~/tf-commands
```{{execute}}

```bash
cat > providers.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
}
EOF
```{{execute}}

```bash
cat > main.tf << 'EOF'
variable "env"  { type = string; default = "dev" }
variable "name" { type = string; default = "cr-it" }

resource "random_id" "id" { byte_length = 4 }

resource "local_file" "config" {
  content = <<-CFG
    env=${var.env}
    name=${var.name}
    id=${random_id.id.hex}
  CFG
  filename = "/tmp/tf-cmds/${var.name}-${var.env}.conf"
  file_permission = "0644"
}

output "config_path" { value = local_file.config.filename }
output "deploy_id"   { value = random_id.id.hex }
EOF
```{{execute}}
