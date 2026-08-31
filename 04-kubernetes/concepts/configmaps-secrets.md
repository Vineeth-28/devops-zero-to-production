# ConfigMaps & Secrets

## What it is
- A **ConfigMap** stores non-sensitive configuration data as key-value
  pairs.
- A **Secret** stores sensitive data (passwords, tokens, keys), also as
  key-value pairs, but base64-encoded.

## Why we use it
Configuration should not be baked into the container image — the same
image should run in dev/staging/production with different config injected
at deploy time.

## How it works

- Values can be injected as **environment variables** (`env`/`envFrom`) or
  **mounted as files** into the container (`volumeMounts`).
- `envFrom` injects every key in a ConfigMap/Secret as an env var at once;
  `env` with `valueFrom` injects one specific key.

**Important**: Secrets are base64-**encoded**, not encrypted, by default.
Anyone with API access to read the Secret can trivially decode it. Real
encryption requires enabling encryption at rest for etcd (or using an
external secrets manager).

## Example — as environment variables

```yaml
envFrom:
  - configMapRef:
      name: backend-config
env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: DB_PASSWORD
```

## Example — as a mounted file

```yaml
volumes:
  - name: config-volume
    configMap:
      name: backend-config
volumeMounts:
  - name: config-volume
    mountPath: /etc/config
```

## Common mistakes

- Assuming Secrets are encrypted just because they look encoded.
- Committing real Secret manifests (with real base64 values) to Git.
- Hardcoding config values in the image instead of injecting via
  ConfigMap/Secret.

## Production considerations

- Enable etcd encryption at rest, and prefer an external secrets manager
  with a Kubernetes integration for real credentials.
- Use separate ConfigMaps per environment rather than one giant ConfigMap
  with environment-conditional keys.

## Interview questions

- Is a Kubernetes Secret encrypted? What would make it actually secure?
- Difference between `env` and `envFrom`?
- How would you mount a ConfigMap as a file instead of an env var?
