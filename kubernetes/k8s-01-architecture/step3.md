# Шаг 3: Worker Node

Worker Node — сервер, где реально работают ваши приложения.

- **kubelet** — агент K8s. Получает задание от API Server → говорит containerd что запустить.
- **kube-proxy** — настраивает iptables/IPVS чтобы трафик доходил до подов.
- **containerd** — движок контейнеров: скачивает образы, изолирует процессы.

```bash
ssh node01 "systemctl is-active kubelet"
```{{execute}}

```bash
kubectl describe node node01 | head -40
```{{execute}}

В выводе найдите секции **Capacity** (всего ресурсов) и **Allocatable** (можно отдать подам).
