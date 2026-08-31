# Volumes & PVC Commands

## What it is
Commands for working with Volumes, PersistentVolumes (PV), and
PersistentVolumeClaims (PVC).

## Why we use it
Container filesystems are ephemeral — persistent storage is required for
stateful workloads like databases.

## Commands

```bash
kubectl get pv
kubectl get pvc
kubectl get pvc -n <namespace>
kubectl describe pvc <name>
kubectl describe pv <name>

kubectl get storageclass
kubectl describe storageclass <name>

kubectl apply -f pvc.yaml
kubectl delete pvc <name>
```

## Example

```bash
kubectl describe pvc mysql-data
```
Shows the PVC's status (`Bound`/`Pending`), the PV it's bound to, and the
StorageClass used — the first check when a Pod is stuck due to storage.

## Common mistakes

- Deleting a PVC assuming the underlying data is immediately gone — the
  reclaim policy on the PV determines that.
- Requesting a StorageClass that doesn't exist in the cluster, leaving the
  PVC `Pending` forever.

## Production considerations

- Use a `Retain` reclaim policy for critical data PVs so accidental PVC
  deletion doesn't destroy data immediately.

## Interview questions

- What's the relationship between a Pod, a PVC, and a PV?
- Why might a PVC stay in `Pending` state?
- Does deleting a Pod delete its persistent data?
