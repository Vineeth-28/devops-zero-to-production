# Storage

## What it is
Kubernetes storage abstractions that let Pods use disk storage that
survives beyond the Pod's own lifecycle.

## Why we use it
A container's own filesystem is ephemeral — it disappears when the
container is removed. Stateful workloads (databases, file uploads) need
storage that outlives any single Pod.

## How it works

| Concept | Role |
|---|---|
| Volume | Storage attached to a Pod's lifecycle (some types persist beyond a container restart, but are tied to the Pod) |
| PersistentVolume (PV) | A piece of storage provisioned in the cluster, independent of any Pod |
| PersistentVolumeClaim (PVC) | A request for storage by a user/Pod; gets bound to a matching PV |
| StorageClass | Defines *how* storage is dynamically provisioned (which backend, parameters) |

With **dynamic provisioning**, you don't pre-create PVs manually — creating
a PVC against a StorageClass automatically provisions a matching PV.

## Diagram

```text
Pod
 │
 ▼
PVC
 │
 ▼
PV
 │
 ▼
Storage
```

## Why deleting a Pod doesn't delete the data

A PVC is a separate object from the Pod. When a Pod is deleted (and even
recreated by its Deployment), the PVC — and the underlying PV/storage — is
untouched, and the *new* Pod mounts the *same* PVC. Data is only actually
lost if the PVC itself is deleted **and** the PV's reclaim policy is
`Delete`.

## Example

```bash
kubectl get pvc
kubectl describe pvc mysql-data
kubectl get pv
kubectl get storageclass
```

## Common mistakes

- Assuming persistent data is lost whenever a Pod restarts — it isn't, as
  long as the PVC still exists.
- Using `emptyDir` (a Volume type, not persistent) for data that actually
  needs to survive Pod deletion.

## Production considerations

- Use `Retain` reclaim policy for critical PVs so a PVC deletion doesn't
  immediately destroy the underlying data.
- Match `accessModes` (`ReadWriteOnce`, `ReadOnlyMany`, `ReadWriteMany`) to
  what your storage backend actually supports.

## Interview questions

- What's the relationship between a PV and a PVC?
- Why doesn't deleting a Pod delete its persistent data?
- What does a StorageClass do in dynamic provisioning?
