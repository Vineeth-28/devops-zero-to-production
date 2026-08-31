# Troubleshooting: Storage

## PVC Pending

```bash
kubectl get pvc
kubectl describe pvc <name>
```

Possible causes:

- No PersistentVolume available that satisfies the request (size, access
  mode).
- Wrong or misspelled `storageClassName`.
- Provisioner issue — the dynamic provisioner failed to create a volume
  (check provisioner/controller logs).
- Underlying storage backend unavailable or out of capacity.
- Unsupported `accessMode` for the requested StorageClass/backend.

## Pod stuck Pending due to storage

If a Pod references a PVC that is itself Pending, the Pod cannot start.
Always check PVC status *before* digging into Pod-level scheduling issues
when storage is involved.

```bash
kubectl describe pod <pod-name>
# look for: "pod has unbound immediate PersistentVolumeClaims"
kubectl describe pvc <pvc-name>
```

## Data appears "lost" after a Pod restart

- Confirm the Pod actually references a PVC (not `emptyDir`, which is
  genuinely ephemeral).
- Confirm the new Pod is mounting the *same* PVC name as before.
- Check the PV's reclaim policy — `Delete` reclaim policy on a deleted PVC
  really does remove the backing storage.

## Common mistakes

- Assuming any Volume type is persistent — only PV/PVC-backed volumes
  survive Pod deletion; `emptyDir` does not.
- Not checking `kubectl describe storageclass` when a PVC is Pending —
  provisioner misconfiguration is a common but easy-to-miss cause.

## Production considerations

- Use `Retain` reclaim policy on PVs holding critical data so accidental
  PVC deletion doesn't immediately destroy the backing storage.
