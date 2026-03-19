# Helm Part 1 + Part 2 Complete!

## What we learned

**Part 1 - Fundamentals**

- **helm create** - generate chart scaffold
- **Chart.yaml** - version vs appVersion, type: application/library
- **values.yaml** - all data types: string, int, bool, list, map
- **helm install/upgrade/rollback/uninstall** - release lifecycle
- **--set / --values** - override priority chain
- **helm repo add** - install from Bitnami and ArtifactHub
- **helm list/history/get** - inspect running releases

**Part 2 - Own Chart**

- **Template syntax** - .Values .Release .Chart built-in objects
- **Functions** - default, quote, toYaml, nindent, printf, ternary
- **Conditionals** - if/else/with with and/or/eq operators
- **Loops** - range over lists and maps with $key/$value
- **_helpers.tpl** - define/include for reusable named templates
- **Complete devapp chart** - Deployment + Service + ConfigMap + Ingress
- **helm lint/template/package** - dev workflow
- **Multi-env values** - dev/staging/prod with separate values files

## Quick Reference

```bash
helm create chart-name
helm install release-name ./chart
helm install release-name ./chart --values prod.yaml --set key=val
helm upgrade --install release-name ./chart
helm upgrade --install release-name ./chart --atomic
helm rollback release-name 1
helm history release-name
helm list --all-namespaces
helm template release-name ./chart -s templates/deployment.yaml
helm lint ./chart
helm package ./chart
helm uninstall release-name
```

## Next module

**StatefulSet** - stable pod names, ordered deploy, individual PVCs for databases and queues.
