# Module complete!

## What we learned

- **Liveness Probe** - detects dead/stuck containers, triggers restart
- **Readiness Probe** - detects not-ready containers, removes from Service endpoints
- **Startup Probe** - protects slow-start containers from premature liveness checks
- **httpGet** - best for web apps, checks HTTP response code (200-399 = success)
- **exec** - runs command inside container, exit code 0 = success
- **tcpSocket** - checks if TCP port accepts connections
- **timeoutSeconds** - most overlooked param, default 1s causes false failures under load
- **failureThreshold + periodSeconds** = total window before action
- **successThreshold** - how many successes needed to recover (readiness: often 2+)

## Quick Reference

```bash
kubectl describe pod NAME | grep -A8 'Liveness:\|Readiness:\|Startup:'
kubectl get events --field-selector reason=Unhealthy
kubectl get pod NAME -o jsonpath='{.status.containerStatuses[0].restartCount}'
kubectl get endpoints SERVICE_NAME
```

## Decision guide

```
App crashes when broken?  -> Liveness Probe
App needs warm-up time?   -> Readiness Probe
App starts slowly (JVM)?  -> Startup Probe + Liveness
Database dependency?      -> Readiness Probe (don't liveness check deps)
```

## Next module

**Resource Requests and Limits** - CPU/memory management, QoS classes, LimitRange, ResourceQuota.
