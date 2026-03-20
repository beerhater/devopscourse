# Шаг 6: Публичный реестр — registry.terraform.io

## Что такое Terraform Registry

```bash
cat << 'EOF'
registry.terraform.io — официальный реестр модулей HashiCorp.

  Адрес модуля: NAMESPACE/MODULE_NAME/PROVIDER
    hashicorp/consul/aws      -> официальный модуль HashiCorp
    terraform-aws-modules/vpc/aws  -> популярный community модуль

  В source:
    source  = "hashicorp/consul/aws"
    version = "~> 0.4"

  Страница модуля показывает:
    - Все inputs (variables)
    - Все outputs
    - Версии и changelog
    - README с примерами
    - Исходный код на GitHub
EOF
```{{execute}}

## Синтаксис version constraints

```bash
cat << 'EOF'
version = "~> 1.2"      >= 1.2.0, < 2.0.0  (рекомендуется)
version = "~> 1.2.3"    >= 1.2.3, < 1.3.0  (только patch)
version = ">= 1.0"      любая >= 1.0
version = "= 1.5.0"     точно 1.5.0
version = ">= 1.0, < 2" диапазон
version = "1.5.0"       точно 1.5.0 (без оператора)
EOF
```{{execute}}

## terraform-aws-modules/vpc/aws — самый популярный модуль

```bash
cat << 'EOF'
# Пример использования реестр-модуля (не запускаем — нет AWS)

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

# Используем outputs VPC модуля:
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  vpc_id          = module.vpc.vpc_id          # <- output VPC модуля
  subnet_ids      = module.vpc.private_subnets # <- output VPC модуля
}
EOF
```{{execute}}

## terraform-aws-modules/random — используем с MinIO нет, поставим hashicorp/random

```bash
cat << 'EOF'
Популярные модули в реестре:

  terraform-aws-modules/vpc/aws          -> VPC, суbnets, NAT
  terraform-aws-modules/eks/aws          -> Kubernetes кластер
  terraform-aws-modules/rds/aws          -> PostgreSQL, MySQL
  terraform-aws-modules/s3-bucket/aws    -> S3 bucket с best practices
  terraform-aws-modules/security-group   -> Security Groups
  terraform-aws-modules/iam/aws          -> IAM роли и политики

  Yandex Cloud:
  yandex-cloud/yandex                    -> провайдер Яндекса

  Как найти модуль:
    https://registry.terraform.io/browse/modules
    Фильтр по провайдеру: AWS, GCP, Azure, Yandex
    Сортировка: Most Downloads, Recently Published

  Как оценить качество модуля:
    ✅ Verified (синяя галочка) — проверен HashiCorp
    ✅ Много загрузок и звёзд GitHub
    ✅ Активное обновление (commit недавно)
    ✅ Полная документация inputs/outputs
    ✅ Примеры в examples/
EOF
```{{execute}}

## terraform init с реестр-модулем (сухой запуск)

```bash
mkdir -p ~/tf-registry-demo && cd ~/tf-registry-demo
```{{execute}}

```bash
# Используем модуль из реестра (hashicorp/dir/template — простой пример)
cat > main.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    random = { source = "hashicorp/random", version = "~> 3.4" }
  }
}

# random модуль создаём сами для демонстрации синтаксиса
module "ids" {
  source  = "hashicorp/dir/template"
  version = "~> 1.0"
}
EOF
```{{execute}}

```bash
# init покажет что скачивает из реестра
terraform init 2>&1 | head -20 || true
```{{execute}}

```bash
cat << 'EOF'
При terraform init с реестр-модулем:
  Downloading registry.terraform.io/hashicorp/dir/template v1.0.2...
  - Installing hashicorp/dir/template v1.0.2...

Кэш: ~/.terraform.d/plugin-cache/
      .terraform/modules/ids/

terraform providers  <- показывает все используемые провайдеры
EOF
```{{execute}}
