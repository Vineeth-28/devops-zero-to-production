# ConfigMap & Secret Commands

## What it is
Commands to create and inspect ConfigMaps (non-sensitive config) and
Secrets (sensitive values).

## Why we use it
Keeps configuration and credentials out of container images and application
code.

## Commands

```bash
kubectl create configmap app-config --from-literal=APP_ENV=production
kubectl create configmap app-config --from-file=config.properties
kubectl get configmaps
kubectl describe configmap app-config

kubectl create secret generic db-secret \
  --from-literal=DB_PASSWORD=changeme
kubectl get secrets
kubectl describe secret db-secret
kubectl get secret db-secret -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode

kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
```

## Example

```bash
kubectl get secret db-secret -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode
```
Decodes a Secret value locally — demonstrates that base64 is encoding, not
encryption.

## Common mistakes

- Treating Secrets as encrypted because the values are base64-encoded — they
  are only encoded, not encrypted, unless encryption at rest is configured.
- Committing real Secret YAML (with real base64 values) into Git.

## Production considerations

- Enable encryption at rest for etcd, and consider an external secrets
  manager (Vault, AWS Secrets Manager) for real production secrets.
- Use `--from-literal` for quick testing only; use sealed/external secrets
  for anything real.

## Interview questions

- Is a Kubernetes Secret encrypted by default?
- What's the difference between a ConfigMap and a Secret?
- How would you inject a ConfigMap value as an environment variable vs a
  mounted file?
