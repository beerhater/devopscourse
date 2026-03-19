# Liveness and Readiness Probes

Without probes, K8s thinks a container is healthy as long as the process runs.
A web server may be up but returning 500 errors -- K8s will keep sending traffic.

```
Liveness Probe  -- is the container alive? Fail = restart container
Readiness Probe -- is the container ready? Fail = remove from Service endpoints
Startup Probe   -- has the container started? Blocks liveness until it passes
```

## What we will learn

- Why probes matter: zombie processes and slow starts
- Liveness Probe: httpGet, exec, tcpSocket
- Readiness Probe: traffic control without restart
- Startup Probe: protecting slow-start containers
- Probe parameters: initialDelay, period, timeout, threshold
- Liveness vs Readiness: when to use which
- Real example: nginx + backend with all three probes

> Check cluster: `kubectl get nodes`{{execute}}
