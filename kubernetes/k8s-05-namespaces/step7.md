# Шаг 7: kubens и kubectx — удобные инструменты

`kubectx` переключает кластеры, `kubens` переключает namespace — одной командой без длинного `kubectl config set-context`.

## Установка

```bash
# Устанавливаем через apt или скачиваем бинарник
apt-get install -y kubectx 2>/dev/null ||   (curl -sLo /usr/local/bin/kubectx https://github.com/ahmetb/kubectx/releases/latest/download/kubectx &&    curl -sLo /usr/local/bin/kubens https://github.com/ahmetb/kubectx/releases/latest/download/kubens &&    chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens) ||   echo "Установка не удалась — используем встроенный alias"
```{{execute}}

## Если kubens недоступен — делаем alias

```bash
# Универсальный alias который работает везде
cat >> ~/.bashrc << 'ALIASES'

# Quick namespace switch
alias kns='kubectl config set-context --current --namespace'
alias kctx='kubectl config use-context'

# Show current namespace in prompt
kns_current() { kubectl config view --minify --output 'jsonpath={.contexts[0].context.namespace}' 2>/dev/null || echo "default"; }
ALIASES

source ~/.bashrc
echo "Aliases загружены"
```{{execute}}

```bash
# Теперь можно быстро переключаться
kns development
kubectl get deployments
```{{execute}}

```bash
kns staging
kubectl get deployments
```{{execute}}

```bash
kns default
```{{execute}}

## kubens (если установлен)

```bash
# Список всех namespace
kubens 2>/dev/null || echo "kubens: используем alias kns"
```{{execute}}

```bash
# Переключение
kubens development 2>/dev/null || kns development
kubectl get all
```{{execute}}

```bash
kubens default 2>/dev/null || kns default
```{{execute}}

## Полезные алиасы для работы с namespace

```bash
cat >> ~/.bashrc << 'MOREALIASES'

# kubectl сокращения
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgd='kubectl get deployments'
alias kgs='kubectl get services'
alias kgn='kubectl get namespaces'
MOREALIASES

source ~/.bashrc
echo "Алиасы добавлены"
```{{execute}}

```bash
kgpa
```{{execute}}
