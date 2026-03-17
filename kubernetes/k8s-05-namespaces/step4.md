# Шаг 4: Изоляция ресурсов — что видно, что нет

Namespace изолируют большинство объектов K8s. Разберём что изолируется, а что нет.

## Namespaced vs Cluster-wide ресурсы

```bash
# Посмотрим какие ресурсы namespaced
kubectl api-resources --namespaced=true | head -20
```{{execute}}

```bash
# А какие — кластерные (не привязаны к namespace)
kubectl api-resources --namespaced=false
```{{execute}}

`Node`, `PersistentVolume`, `ClusterRole`, `Namespace` — кластерные ресурсы, существуют вне namespace.

## Практика: деплоим одинаковые имена в разных namespace

```bash
# Одно имя — разные ресурсы в разных namespace
kubectl create deployment my-app --image=nginx:alpine -n development
kubectl create deployment my-app --image=httpd:alpine -n staging
kubectl create deployment my-app --image=nginx:1.24 -n production
```{{execute}}

```bash
# Конфликта нет — они изолированы
kubectl get deployments -A | grep my-app
```{{execute}}

```bash
# Разные образы в одноимённых деплойментах
kubectl get deployment my-app -n development -o jsonpath='{.spec.template.spec.containers[0].image}'
echo " (development)"
kubectl get deployment my-app -n staging -o jsonpath='{.spec.template.spec.containers[0].image}'
echo " (staging)"
kubectl get deployment my-app -n production -o jsonpath='{.spec.template.spec.containers[0].image}'
echo " (production)"
```{{execute}}

## Service изолированы — но DNS позволяет обращаться между namespace

```bash
kubectl expose deployment my-app --port=80 -n development
kubectl expose deployment my-app --port=80 -n staging
```{{execute}}

```bash
# Service видны только в своём namespace
kubectl get services -n development
kubectl get services -n staging
```{{execute}}

```bash
# Из пода в development обратиться к staging можно по полному DNS-имени
# http://my-app.staging.svc.cluster.local
# Но НЕ по короткому имени my-app (это будет development)
kubectl run dns-test --image=busybox --rm -it --restart=Never -n development   -- nslookup my-app.staging.svc.cluster.local
```{{execute}}
